class Seller < ActiveRecord::Base
  belongs_to :member
  belongs_to :shipping_term
  has_many :products
  has_many :line_items, :through => :products, :order => "order_id DESC", :include => [:feedback]
  
  validates_presence_of     :name
  validates_length_of       :name,    :within => 3..120
  validates_uniqueness_of   :name
  
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of     :accepted_terms
  
  def feedback 
    line_items.collect {|li| li.feedback}.compact
  end
  
  def feedback_rating 
    (feedback.blank?) ? nil : feedback.sum{|f| f.rating}/feedback.size
  end
  
  def unshipped_items
    line_items.select {|li| li.buyer_paid?}
  end
  
  def available_products
    products.available
  end
  
  def available_products_count
    available_products.size
  end
  
  def unpaid_items
    line_items.select {|li| li.unpaid?}
  end
  
  def sold_items
    line_items.select {|li| li.purchased?}
  end
  
  def outstanding_revenue
    return Money.new(0) if unpaid_items.blank?
    my_unpaid = unpaid_items.sum{|item| item.total_cents - item.transaction_cents}
    Money.new(my_unpaid)
  end
  
  def total_items_sold
    sold_items.size
  end
  
  def total_revenue
    return Money.new(0) if sold_items.blank?
    rev = sold_items.sum{|item| item.total_cents - item.transaction_cents}
    Money.new(rev)
  end
 
end
