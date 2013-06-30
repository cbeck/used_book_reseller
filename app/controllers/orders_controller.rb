class OrdersController < ApplicationController
  before_filter :activate_tab, :shop_navigation, :set_current_item
  before_filter :show_menu, :except => [:new]
  # GET /orders
  # GET /orders.xml
  def index
    @orders = (logged_in? ) ? Order.buyer(current_member).purchased : []
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @orders.to_xml }
    end
  end
  
  # GET /orders/1
  # GET /orders/1.xml
  def show
    begin
      if @cart.id == params[:id].to_i
        render :action => "checkout"
      else
        session[:foo]   # lazy loading session patch.  see: http://bit.ly/1pvTLv
        @order = (logged_in?) ? current_member.orders.find(params[:id]) : Order.find_by_session_id(request.session_options[:id])
      end
    rescue
      flash[:notice] = "This order is not yours or cannot be found."
    end
  end
  
  def complete
    begin 
      session[:foo]   # lazy loading session patch.  see: http://bit.ly/1pvTLv
      @order = (logged_in?) ? current_member.orders.find(params[:id]) : Order.find_by_session_id(request.session_options[:id])
    rescue 
      nil
    end
    unless @order.nil?
      if !@order.paid?
        PaymentNotification.create!(:params => params, :order_id => params[:invoice], 
          :status => params[:payment_status], :transaction_id => params[:txn_id])
      end
      redirect_to order_path(@order)
    else
      flash[:notice] = "There was a problem completing this order. Please contact customer service at support@homeschoolapple.com"
      redirect_to home_path
    end
  end
  
  def cancel
    @cart.cancel!
    redirect_to home_path
  end
  
  # GET /orders/new
  # def new    
  #   @current_item = nil
  #   if @cart.empty?
  #     redirect_to_index("Your cart is empty" )
  #   elsif !logged_in?
  #     flash[:notice] = "Please log in or create an account to continue."          
  #     store_location      
  #     redirect_to login_path
  #   else
  #     @cart = Order.new
  #     @cart.email = self.current_member.email
  #     @last_order = Order.find(:first, :conditions => ["member_id = ?", current_member], :order => "id DESC")
  #     @cart = prepopulate_order(@cart, @last_order) unless @last_order.nil?
  # 
  #   end
  # end
  
  def destroy
    @cart.empty_cart
    flash[:notice] = "Your cart is now empty"
  end
  
  private
  
  def ship_to_billing (order)
    order.ship_address_line_1 = order.address_line_1
    order.ship_address_line_2 = order.address_line_2
    order.ship_city = order.city
    order.ship_state = order.state
    order.ship_zip = order.zip
    order.ship_country = order.country
    return order
  end
  
  def prepopulate_order (order, last_order)
    order.name = last_order.name
    order.email = last_order.email
    order.address_line_1 = last_order.address_line_1
    order.address_line_2 = last_order.address_line_2
    order.city = last_order.city
    order.state = last_order.state
    order.zip = last_order.zip
    order.country = last_order.country
    order.ship_address_line_1 = last_order.ship_address_line_1
    order.ship_address_line_2 = last_order.ship_address_line_2
    order.ship_city = last_order.ship_city
    order.ship_state = last_order.ship_state
    order.ship_zip = last_order.ship_zip
    order.ship_country = last_order.ship_country
    order.pay_info = last_order.pay_info
    order.pay_type = last_order.pay_type
    order.ship_to = last_order.ship_to
    return order
  end
  
  def activate_tab
    @active_tab = "shop_tab"
  end
  
  def set_current_item
    @current_item = "my_purchases"
  end
end