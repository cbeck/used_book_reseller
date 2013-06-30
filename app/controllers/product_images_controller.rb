class ProductImagesController < ApplicationController
  before_filter :login_required, :only => [:create, :new, :index, :destroy]
  before_filter :find_product_image, :except => [:new, :index, :create, :sort]
  before_filter :find_seller, :only => [:create, :new, :index, :destroy]
  before_filter :activate_tab, :set_current_item
  before_filter :sell_navigation, :except => :detail
  
  
  # GET /products/4/product_images/new
  def new
    @product = @seller.products.find(params[:product_id])
    @product_image = ProductImage.new
  end 
 
  # GET /products/4/product_images
  # GET /products/4/product_images.xml  
  def index
    @product = @seller.products.find(params[:product_id])    
  end
 
  # POST /products/4/product_images
  # POST products/4/product_images.xml
  def create
      @product_image = ProductImage.new(params[:product_image])
      @product = @seller.products.find(params[:product_id])
      @product_image.product = @product
      if @product_image.save        
        redirect_to product_product_images_url(@product)
      else
        flash[:notice] = 'Sorry, but we are unable to process this image. Please try again or select a different image.'
        render :action => :new
      end
  end
  
  def destroy
    @product_image.destroy
  end
  
  
  protected 
  
  def find_product_image
    @product_image = ProductImage.find(params[:id])
  end
  
  private
  
  def activate_tab
    @active_tab = "sell_tab"
  end
  
  def set_current_item
    @current_item = "my_products"
  end
end
