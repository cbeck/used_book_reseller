class ProductsController < ApplicationController
  before_filter :login_required, :except => :detail
  before_filter :activate_tab, :set_current_item
  before_filter :sell_navigation, :except => :detail
  before_filter :shop_navigation, :only => :detail
  before_filter :find_seller, :except => [:detail, :show] 
  before_filter :find_seller_product, :except => [:index, :new, :create, :detail, :show]
  before_filter :show_menu, :except => [:detail]  
    
  
  # GET /products
  # GET /products.xml
  def index
    store_location
    @filter = params[:filter] || "title"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    
    @products = @seller.products.find(:all, :order => filter)
    @products = @products.select {|p| p.sellable?}
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @products.to_xml }
    end
  end
  
  # GET /products/1
  # GET /products/1.xml
  def show
    # special case for show - we'll be a little nicer and redirect
    begin
        @product = current_member.seller.products.find(params[:id])
     rescue
     end
    respond_to do |format|
      if @product.nil?
        format.html {redirect_to detail_product_path(params[:id])}
      else
        format.html # show.rhtml
        format.xml  { render :xml => @product.to_xml }
      end
    end
  end
  
  # POST /products/new
  def new 
    @current_list = "Not Available"
    
    # for new stuff, parse out ASIN, then call load_from_amazon
    # this will stuff it in the model
    unless params[:product].nil? || params[:product][:isbn].blank?
      isbn = params[:product][:isbn]
      asin = isbn.gsub(/\W/,'')

      @product = Product.load_from_amazon(asin, true)       
      if @product.title.blank? && (isbn.count("0-9") < 9)
        @no_isbn = true
        @product = Product.new(:title => isbn)
      elsif @product.title.blank?
        @product = Product.new(:isbn => isbn)
      end
    else
      @product = Product.new
    end
    @media_mail = (@product.shipping_weight.blank?) ? nil : MediaMail.get_rate(@product.shipping_weight)
    @statuses = [Status[:Available], Status['Currently Unavailable']]
  end
  
  # GET /products/1;edit
  def edit
    @statuses = Status.find(:all)
    @media_mail = (@product.shipping_weight.blank?) ? nil : MediaMail.get_rate(@product.shipping_weight)
  end

  # POST /products
  # POST /products.xml
  def create
    @product = Product.new(params[:product])
    @product.seller_id = @seller.id
    @product.published = true
    @product.publish_at = Time.now.utc
    @product.status = Status['Available'] if params[:product][:status_id].blank?
    @product.offer_price = purefy_offer_price(params[:offer_price])
    
    respond_to do |format|
      if @product.save
        flash[:notice] = 'Product was successfully created.'
        path = (params[:go_to_images] == "true") ? new_product_product_image_path(@product) : product_path(@product)
        
        format.html { redirect_to path }
        format.xml do
          headers["Location"] = product_url(@product)
          render :nothing => true, :status => "201 Created"
        end
      else
        @statuses = [Status[:Available], Status['Currently Unavailable']]
        flash[:notice] = 'Oops! You made a slight mistake. Please check your form and try again.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @product.errors.to_xml }
      end
    end
  end
  
  # PUT /products/1
  # PUT /products/1.xml
  def update
    @product = @seller.products.find(params[:id])
    @product.offer_price = purefy_offer_price(params[:offer_price])
    
    respond_to do |format|
      if @product.update_attributes(params[:product])
        flash[:notice] = 'Your product was sucessfully updated!'
        format.html { 
          if params[:go_to_images] == "true"
            redirect_to new_product_product_image_path(@product) 
          else
            redirect_to @product
          end
        }
        format.xml  { render :nothing => true }
      else
        @statuses = Status.find(:all)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product.errors.to_xml }        
      end
    end
  end
  
  # DELETE /products/1
  # DELETE /products/1.xml
  def destroy
    @product = @seller.products.find(params[:id])
    @product.destroy
    
    respond_to do |format|
      format.html { redirect_to products_url   }
      format.js
      format.xml  { render :nothing => true }
    end
  end
  
  # GET /products/1;details
  # GET /products/1;details.xml
  def detail
    begin
      @product = Product.available.find(params[:id])
    rescue
      @product = (@cart.blank?) ? nil : @cart.find_product(params[:id])
    end
    @active_tab = "shop_tab"   
    @current_item = "find_products"   
    
    respond_to do |format|
      unless @product.nil?
        format.html # detail.rhtml
        format.xml  { render :xml => @product.to_xml }
      else
        flash[:notice] = "That product is no longer available."
        format.html {redirect_back_or_default(categories_path)}
        format.xml  { render :nothing => true }
      end
    end
  end
  
  def toggle_status
    status = (@product.status == Status[:Available]) ? Status["Currently Unavailable"] : Status[:Available]
    
    respond_to do |format|
      if @product.update_attribute(:status, status)   
        flash[:notice] = "Your product is now #{status.name}"
        format.js
      else
        flash[:notice] = "There was a problem updating this product's status." 
        format.js  
      end
    end
    
  end
  
  def sort_product_images
    
    unless @product.nil?      
      @product.product_images.each do |image|
        image.position = params['product_images'].index(image.id.to_s) + 1
        image.save
      end
    end
    render :nothing => true 
  end
  
  def toggle_default_image
    @product = @seller.products.find(params[:id])
    use_amazon = (@product.has_product_images? && (@product.product_images.empty? || !@product.use_amazon_image?)) ? true : false
    
    respond_to do |format|
      if @product.update_attribute(:use_amazon_image, use_amazon)   
        flash[:notice] = "Your successfully updated your default image for this product."
        format.js
      else
        flash[:notice] = "There was a problem the default image for this product." 
        format.js  
      end
    end
    
  end
  
  
  private
  
  def activate_tab
    @active_tab = "sell_tab"
  end
  
  def set_current_item
    @current_item = "my_products"
  end
  
  def find_seller_product
     begin
        @product = current_member.seller.products.find(params[:id])
     rescue
       flash[:notice] = 'The product you attempted to access is not one of yours.'
       redirect_to products_path
     end
  end
  
  def purefy_offer_price(offer)
    unless offer.blank?
      offer_price = offer.strip
      last_char = offer_price.reverse[0]
      offer_price = offer_price.chop if last_char == 46
      offer = offer_price.to_money 
    end
    offer
  end
  
  
end