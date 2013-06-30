class LineItem < ActiveRecord::Base
  include AASM
  belongs_to :order
  belongs_to :product
  belongs_to :carrier
  has_one :feedback, :dependent => :destroy
  composed_of :total_price, :class_name => "Money", 
    :mapping => [%w(total_cents cents), %w(currency currency)]
    
  
  aasm_column :status
  aasm_initial_state :pending
  aasm_state :pending
  aasm_state :buyer_paid, :enter => :decrease_product_quantity
  aasm_state :shipping_ack, :enter => :enter_shipping_state
  aasm_state :shipping_verified
  aasm_state :delivery_ack
  aasm_state :delivery_verified
  aasm_state :seller_paid
  aasm_state :returned
  aasm_state :cancelled

  aasm_event :buyer_paid do
    transitions :from => :pending, :to => :buyer_paid
  end
  aasm_event :shipped do
    transitions :from => :buyer_paid, :to => :shipping_ack
    transitions :from => :shipping_ack, :to => :shipping_ack
  end
  aasm_event :shipping_verified do
    transitions :from => [:shipping_ack], :to => :shipping_verified
  end
  aasm_event :delivery_ack do
    transitions :from => [:shipping_ack, :shipping_verified], :to => :delivery_ack
  end
  aasm_event :delivery_verified do
    transitions :from => [:shipping_ack, :shipping_verified], :to => :delivery_verified
  end
  aasm_event :seller_paid do
    transitions :from => [:delivery_ack, :delivery_verified], :to => :seller_paid
  end
  aasm_event :returned do
    transitions :from => [:delivery_ack, :delivery_verified, :seller_paid], :to => :returned
  end
  aasm_event :cancelled do
    transitions :from => [:buyer_paid], :to => :cancelled
  end
  
  def title
    product.title
  end
  
  def price
    product.offer_price * quantity
  end
  
  def transaction_fee
    cut_off_date = Date.new(2009,10,11).to_time
    (total_price.blank? || total_price == Money.new(0) || product.created_at < cut_off_date) ? ((total_price) * 0.03) + Money.new(35) : ((total_price) * 0.03) + Money.new(134)
  end
  
  def transaction_cents
     transaction_fee.cents
   end
  
  def seller
    product.seller
  end
  
  def has_feedback? 
    !feedback.nil?
  end
  
  def purchased?
    ["buyer_paid", "shipped", "shipping_ack", "shipping_verified", "delivery_ack", "delivery_verified", "seller_paid"].include? status
  end
  
  def unpaid? 
    ["buyer_paid", "shipped", "shipping_ack", "shipping_verified", "delivery_ack", "delivery_verified"].include? status
  end
  
  def shipping_entered?
    ["shipping_ack", "shipping_verified", "delivery_ack", "delivery_verified", 
     "seller_paid", "returned", "cancelled"].include? status
  end
  
  def shipping_locked?
    ["shipping_verified", "delivery_ack", "delivery_verified", 
     "seller_paid", "returned", "cancelled"].include? status
  end
  
  def decrease_product_quantity
    product.update_attribute(:quantity_avail, product.quantity_avail - 1)
  end
  
  def enter_shipping_state
    self.update_attribute(:shipped_at, Time.now.utc)
  end
  
end
