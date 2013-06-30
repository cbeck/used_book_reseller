class Admin::OrdersController < ApplicationController
  before_filter :login_required
	require_role :admin
  
  def index
    @orders = Order.purchased
  end
  
  # GET /orders/1
  # GET /orders/1.xml
  def show
    @order = Order.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @order.to_xml }
    end
  end
  
  # GET /orders/1;edit
  def edit
    @order = Order.find(params[:id])
  end
  
  # PUT /orders/1
  # PUT /orders/1.xml
  def update
    @order = Order.find(params[:id])
    
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to [:admin, @order] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @order.errors.to_xml }        
      end
    end
  end
  
  # DELETE /orders/1
  # DELETE /orders/1.xml
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_orders_url   }
      format.xml  { render :nothing => true }
    end
  end

end
