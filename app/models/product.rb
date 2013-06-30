require 'acts_as_amazon_product'
require 'money'

class Product < ActiveRecord::Base
  HOLD_PERIOD = 15.minutes

  named_scope :available, lambda {
    {:conditions => ['published = ? and status_id = ? and (held_at is null or held_at < ?) and (quantity_avail is null or quantity_avail > 0)', true, Status[:Available], Time.now.utc - HOLD_PERIOD ]}
  }
        
  named_scope :for_category, lambda {|cat|
    {:joins => "join categories_products on category_id = #{cat} and product_id = products.id"}
  }
  
  has_many :line_items
  has_many :orders, :through => :line_items
  has_many :product_images, :order => :position
  belongs_to :status
  belongs_to :seller
  belongs_to :item_format
  belongs_to :condition
  has_and_belongs_to_many :categories
  composed_of :offer_price, :class_name => "Money", 
    :mapping => [%w(offer_cents cents), %w(currency currency)]
  composed_of :retail_price, :class_name => "Money", 
    :mapping => [%w(retail_cents cents), %w(currency currency)]
  
  after_save :log_activity unless ["development", "test"].include? RAILS_ENV
  
  attr_reader :short_description  #, :list_price
  # attr_writer :list_price
  
  acts_as_ferret :fields => [:title, :description, :publisher_name, :author]
  
  acts_as_amazon_product :asin => 'isbn', :name => 'amazon_name',
   :access_key => '17E9TGAJNT3VNJRMVGR2', 
   :secret_key => 'TXE++OwPO5SyLVyWd9y3pLXG9ibfUWjbNmhOYksZ',
   :associate_tag => 'netphase-20',
   :auto_load_fields => {
     :title => 'title', :isbn => 'isbn', 
     :publisher_name => 'manufacturer', 
     :author => 'author', :binding => 'binding', 
     :retail_cents => 'listprice/amount', :retail_currency => 'listprice/currencycode',
     :offer_cents => 'lowestusedprice/amount', :offer_currency => 'lowestusedprice/currencycode',
     :pages => 'numberofpages',
     :description => 'content', :detail_url => 'detailpageurl',
     :small_image_url => 'smallimage/url', :medium_image_url => 'mediumimage/url', 
     :large_image_url => 'largeimage/url', 
     :weight => 'packagedimensions/weight'
   }

  def Product.fetch(isbn, cats=[], status=Status[:Available])
    p = load_from_amazon isbn
    p.category_ids = cats.collect{|c| c.id}
    p.status = status
    p.item_format = case p.amazon.binding
      when "Paperback": ItemFormat[:Paperback]
      when "Hardcover": ItemFormat[:Hardcover]
      else ItemFormat[:Other]
    end
    p
  end
  
  def Product.fetch!(isbn, cats=[])
    fetch(isbn, cats).save
  end

  def format
   # (!item_format.nil?) ? item_format.name : self.amazon.binding
   item_format.name unless item_format.nil?
  end
  
  def image_url
    if has_product_images?
      (use_amazon_image_as_default?) ? self.small_image_url  : "/products/#{self.id}/product_images/#{product_images.first.id}/show_thumb.png"
    else
      IMAGE_NOT_AVAIL
    end
    rescue
      ""
  end
  
  def med_image_url
    if has_product_images?
      (use_amazon_image_as_default?) ? self.medium_image_url  : "/products/#{self.id}/product_images/#{product_images.first.id}/show_featured.png"
    else
      MED_IMAGE_NOT_AVAIL
    end
    rescue
      ""
  end
  
  def full_image_url
    if has_product_images?
      (use_amazon_image_as_default?) ? self.large_image_url  : "/products/#{self.id}/product_images/#{product_images.first.id}/show_full.png"
    else
      LARGE_IMAGE_NOT_AVAIL
    end
    rescue
      ""
  end
  
  def has_product_images?
    !product_images.empty? || has_amazon_image?
  end
  
  def has_amazon_image?
    !self.small_image_url.blank?
  end
  
  def use_amazon_image_as_default?
    has_amazon_image? && (use_amazon_image? || product_images.empty?)
  end  
  
  def add_product_image(img)
    product_images << img    
  end
  
  def short_description
   "%-05.150s..." % description
  end 
  
  def shipping_weight
    (weight.nil?) ? 1 : weight/100 
  end
  
  def available?
    (published? && (status == Status[:Available])) && sellable? && !held?
  end
  
  def sellable?
    quantity_avail.nil? || quantity_avail > 0
  end
  
  def effective_status
    (held?) ? "Held In Cart" : status.name
  end
  
  def held?
    !held_at.nil? && held_at > (Time.now.utc - HOLD_PERIOD)
  end
  
  def short_title
    @title = title    
    if title.size > 28
      @title = "%-05.28s..." % title
    end    
    @title
  end
  
  def self.recently_added
    Product.available.ordered("id DESC")[0..2]
  end
  
  def self.next_available
    Product.recently_added.first
  end
  
  def self.featured
    Product.find(:first, :conditions => ["published = true and status_id = ?", Status[:Available]])
  end

  def hold(holder)
    update_attributes(:held_at => Time.now.utc, :held_by => holder.to_s) #if (held_by.nil? || held_by == holder)
  end
  
  def release(holder)
    update_attributes(:held_at => nil, :held_by => nil) #if held_by == holder.to_s
  end
  
  def self.hold_all(holder, *product_ids)
    ids = product_ids.to_a.flatten
    Product.update_all(["held_at = ?, held_by = ?", Time.now.utc, holder.to_s], 
      ["id in (?) and (held_by = ? or held_at < ?)", ids, holder, Time.now.utc - HOLD_PERIOD]) == ids.size
  end

  def self.release_all(holder, *product_ids)
    ids = product_ids.to_a.flatten
    Product.update_all(["held_at = ?, held_by = ?", nil, nil], :id => ids, :held_by => holder.to_s)
  end
  
  def suggested_shipping_consideration
    Money.new(400)
  end  
  
  def suggested_price
    suggested_price = (offer_price == Money.new(0)) ? Money.new(0) : suggested_shipping_consideration + offer_price + suggested_transaction_fee
  end
  
  def suggested_transaction_fee
    (offer_price == Money.new(0)) ? nil : ((suggested_shipping_consideration + offer_price) * 0.03) + Money.new(35)
  end
  
  protected
  def validate
    errors.add(:offer_cents, "should be at least $.01") if offer_cents.nil? || offer_cents < 0.01
  end
  
  def log_activity
    if self.published?
      self.seller.member.update_attribute(:last_activity, "Uploaded or modified a product for sale")
      self.seller.member.update_attribute(:last_activity_at, Time.now.utc)
    end
  end
  
end
