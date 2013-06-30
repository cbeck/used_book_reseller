class CategoriesController < ApplicationController
  before_filter :activate_tab, :shop_navigation, :set_current_item
  before_filter :find_categories, :get_shopping_pref
  # caches_page :only => [:index, :show]
  
  # GET /categories
  # GET /categories.xml
  def index    
    @filter = params[:filter] || "id"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    @products = Product.available.ordered(filter).with(:product_images, :item_format, :seller, :condition).paginate(:page => params[:page], :order => filter)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @categories.to_xml }
    end
  end
  
  # GET /categories/1
  # GET /categories/1.xml
  def show
    @filter = params[:filter] || "id"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    @category = Category.find(params[:id])
    @products = Product.available.for_category(@category.id).with(:product_images, :item_format, :seller, :condition).paginate(:page => params[:page], :order => filter)
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @category.to_xml }
    end
  end
  
  def change_browser
    @partial = params[:to] || "categories"
    session[:shopping_pref] = @partial
  end
  
  private
  
  def find_categories
    @categories = Category.find(:all, :order => "name ASC")
  end
  
  def activate_tab
    @active_tab = "shop_tab"
  end
  
  def set_current_item
    @current_item = "find_products"
  end
  
  def get_shopping_pref
    @partial = session[:shopping_pref] || "search"
  end
end