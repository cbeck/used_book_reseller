class Order < ActiveRecord::Base
  named_scope :current, lambda { |member|
    {:conditions => ["member_id = ? and purchased_at is null", member]}
  }
  named_scope :buyer, lambda {|member| {:conditions => ["member_id = ?", member]}}
  named_scope :purchased, :conditions => ["purchased_at is not null"], :order => 'created_at desc'
  
  include AASM
  
  # acts_as_paranoid
  has_many :line_items, :dependent => :destroy
  has_many :products, :through => :line_items
  has_many :feedback, :through => :line_items
  has_many :sellers, :through => :products #unique
  belongs_to :member
  belongs_to :session
  has_many :transactions, :class_name => 'OrderTransaction', :dependent => :destroy
  
  # validates_presence_of :name, :address_line_1, :city, :state, :zip, :email
  #, :pay_type, :pay_info
  
  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :paid, :enter => :process_order
  aasm_state :payment_declined
  aasm_state :unknown
  aasm_state :cancelled
  
  # aasm_event :processed do
  #   transitions :to => :paid, :from => [:pending, :payment_declined]
  # end
  
  aasm_event :cancel do
    transitions :to => :cancelled, :from => [:pending, :unknown]
  end
  aasm_event :payment_received do
    transitions :to => :paid, :from => [:pending, :payment_declined]
  end
  aasm_event :payment_decline do
    transitions :to => :payment_declined, :from => [:pending]
  end
  aasm_event :unknown_status do
    transitions :to => :unknown, :from => [:pending, :payment_declined, :paid]
  end
  
  def process_order
    update_attribute(:purchased_at, Time.now.utc)
    line_items.each {|item| item.buyer_paid! }
    # MemberMailer.deliver_buyer_receipt(self)
    line_items.group_by(&:seller).each do |seller, items|
      MemberMailer.deliver_seller_items_purchased(self, seller, items)
    end
  end
  
  def purchased?
    !purchased_at.nil?
  end
  
  def sub_total
    line_items.inject(Money.new(0)){|sum,n| sum + (n.price * n.quantity) }
  end
  
  def transaction_fee
    Money.new(0)
  end
  
  def total_price
    sub_total # + transaction_fee 
  end
  
  def item_count
    line_items.inject(0) {|sum, item| sum + item.quantity}
  end
  
  def authorize_payment(credit_card, options={})
    options[:order_id] = number
    
    transaction do
      authorization = OrderTransaction.authorize(amount, credit_card, options)
      transactions.push(authorization)
      if authorization.success?
        payment_authorized!
      else
        transaction_declined!
      end
      authorization
    end
  end
  
  def capture_payment(options = {})
    transaction do
      capture = OrderTransaction.capture(amount, authorization_reference, options)
      transactions.push(capture)
      if capture.success?
        payment_captured!
      else
        transaction_declined!
      end
      capture
    end
  end
  
  def number
    # CGI:Session.generate_unique_id
    id
  end
  
  def authorization_reference
    if authorization = transactions.find_by_action_and_success('authorization', true, :order => 'id ASC')
      authorization.reference
    end
  end
  
  def find_recent
    find(:all, :condition => "created_at > #{Time.now.utc.months_ago(2)}")
  end
  
  def empty?
    line_items.empty?
  end

  def empty_cart
    holder = (member.blank?) ? session_id : member.id
    Product.release_all(holder, product_ids)
    line_items.clear
  end
  
  def product_ids
    line_items.collect{|item| item.product.id}
  end
  
  def find_product(product_id)
    (product_ids.include? product_id.to_i) ? Product.find(product_id) : nil      
  end
  
  def remove_product(product)
    current_item = line_items.find_by_product_id product
    if current_item.quantity > 1
      current_item.update_attribute(:quantity, current_item.quantity-1)
    else
      line_items.delete current_item
    end
  end
  
  def hold_all(member)
     holder = (member.blank?) ? session_id : member.id
     unless Product.hold_all(holder, product_ids)
       Product.find(:all, :conditions => ["id in (?) and held_by <> ?", product_ids, holder]).each {|p|
         remove_product(p)
       }
       false
     end
     true
  end
  
  def release_items_at
    oldest_hold = Product.minimum('held_at', :conditions => ["id in (?)", product_ids]) || Time.now.utc
    oldest_hold + Product.HOLD_PERIOD
  end
  
  def reduce_product_available_inventory
    line_items.each do |li|
      li.product.quantity_avail -= li.quantity
      li.product.save
    end
  end
  
  def incomplete?
    incomplete_items = []
    incomplete_items += (line_items.select {|li| li.pending?}) unless line_items.nil?
    !incomplete_items.empty?
  end
  
  def unshipped_items
    unshipped = []
    unshipped += line_items.select {|li| li.pending?} unless line_items.nil?
    unshipped    
  end
  
  def paypal_encrypted(return_url, notify_url)
    values = {
      :business => APP_CONFIG[:paypal_email],
      :cmd => '_cart',
      :upload => 1,
      :invoice => id,
      :notify_url => notify_url,
      :return => return_url,
      :cert_id => APP_CONFIG[:paypal_cert_id] #,
      #:handling_cart => transaction_fee
    }
    @line_items.each_with_index do |item, index|
      values.merge!({
        "amount_#{index+1}" => item.product.offer_cents / 100.00,
        "item_name_#{index+1}" => item.product.title,
        "item_number_#{index+1}" => item.product.id,
        "quantity_#{index+1}" => item.quantity
      })
    end
    # "https://www.sandbox.paypal.com/cgi-bin/webscr?"+values.map {|k,v| "#{k}=#{v}" }.join("&")
    encrypt_for_paypal(values)
  end  
  
  PAYPAL_CERT_PEM = File.read("#{Rails.root}/certs/paypal_cert.pem")
  APP_CERT_PEM = File.read("#{Rails.root}/certs/app_cert.pem")
  APP_KEY_PEM = File.read("#{Rails.root}/certs/app_key.pem")
  
  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(APP_CERT_PEM), OpenSSL::PKey::RSA.new(APP_KEY_PEM,''), values.map { |k,v| "#{k}=#{v}"}.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(PAYPAL_CERT_PEM)], signed.to_der, OpenSSL::Cipher::Cipher.new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end
end
