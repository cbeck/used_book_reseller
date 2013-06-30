class LineItemsController < ApplicationController
  before_filter :activate_tab, :sell_navigation, :set_current_item
  before_filter :login_required, :except => [:new, :create, :needs_feedback]
  # before_filter :find_seller, :except => [:create]
  before_filter :show_menu 
  
  # GET /line_items
  # GET /line_items.xml
  def index
    # will implement this later when I figure it out
    @filter = params[:filter] || "id"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    
    if current_member.seller.blank?
      @line_items = []
    else    
      @line_items = current_member.seller.sold_items       
    end

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @line_items.to_xml }
    end
  end
  
  # GET /line_items/1
  # GET /line_items/1.xml
  def show
    @line_item = current_member.seller.line_items.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @line_item.to_xml }
    end
  end
  
  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end
  
  # GET /line_items/1;edit
  def edit
    @line_item = current_member.seller.line_items.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.xml
  def create
    begin
      @product = Product.available.find(params[:product_id])
    rescue
      @product = nil
    end
    @reload = !params[:reload].blank?
    if !@product.nil? && @product.available?
      @line_item = @cart.line_items.create(:product_id => @product.id, :quantity => 1, :total_cents => @product.offer_cents, :currency => @product.currency)

      session[:foo]   # lazy loading session patch.  see: http://bit.ly/1pvTLv
      holder = (logged_in?) ? current_member.id : request.session_options[:id]
      @line_item.product.hold(holder)
      flash[:notice] = "#{@line_item.product.title} is now in your cart"
      render :action => 'create.js.rjs'
      # redirect_to_index unless request.xhr?
    else
      logger.error("Attempt to access invalid product #{params[:product_id]}" )
      flash[:notice] = "Product no longer available"
      render :action => 'not_avail.js.rjs'
    end    
  end
  
  # PUT /line_items/1
  # PUT /line_items/1.xml
  def update
    @line_item = current_member.seller.line_items.find(params[:id])
    action = params[:aasm]
    
    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        unless action.blank?
          @line_item.send(action) if @line_item.respond_to?(action)
        end
        format.html { redirect_to line_item_url(@line_item) }
        format.xml  { render :nothing => true }
        format.js #tracking info added in place
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @line_item.errors.to_xml }        
      end
    end
  end
  
  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
    @line_item = current_member.seller.line_items.find(params[:id])
    @line_item.destroy
    
    respond_to do |format|
      format.html { redirect_to line_items_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  # GET /line_items/buyer_details;1
  # GET /line_items/buyer_details;1.xml
  def buyer
    @line_item = current_member.line_items.find(params[:id])
    @current_item = "my_purchases"
    @active_tab = "shop_tab"
    shop_navigation
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @line_item.to_xml }
    end
  end
  
  def unshipped
    @line_items = current_member.unshipped_items
    @current_item = "ship_items"
  end
  
  def needs_feedback
    @line_items = (logged_in?) ? current_member.needs_feedback : []
    @current_item = "leave_feedback"
    @active_tab = "shop_tab"
    shop_navigation
  end
  
  private
  
  def activate_tab
    @active_tab = "sell_tab"
  end
  
  def set_current_item
    @current_item = "my_sales"
  end
end