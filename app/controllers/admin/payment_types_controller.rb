class Admin::PaymentTypesController < ApplicationController
  before_filter :login_required
	require_role :admin
  
  # GET /payment_types
  # GET /payment_types.xml
  def index
    @payment_types = PaymentType.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @payment_types.to_xml }
    end
  end
  
  # GET /payment_types/1
  # GET /payment_types/1.xml
  def show
    @payment_type = PaymentType.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @payment_type.to_xml }
    end
  end
  
  # GET /payment_types/new
  def new
    @payment_type = PaymentType.new
  end
  
  # GET /payment_types/1;edit
  def edit
    @payment_type = PaymentType.find(params[:id])
  end

  # POST /payment_types
  # POST /payment_types.xml
  def create
    @payment_type = PaymentType.new(params[:payment_type])
    
    respond_to do |format|
      if @payment_type.save
        flash[:notice] = 'PaymentType was successfully created.'
        
        format.html { redirect_to [:admin, @payment_type] }
        format.xml do
          headers["Location"] = [:admin, @payment_type]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment_type.errors.to_xml }
      end
    end
  end
  
  # PUT /payment_types/1
  # PUT /payment_types/1.xml
  def update
    @payment_type = PaymentType.find(params[:id])
    
    respond_to do |format|
      if @payment_type.update_attributes(params[:payment_type])
        format.html { redirect_to [:admin, @payment_type] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment_type.errors.to_xml }        
      end
    end
  end
  
  # DELETE /payment_types/1
  # DELETE /payment_types/1.xml
  def destroy
    @payment_type = PaymentType.find(params[:id])
    @payment_type.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_payment_types_url   }
      format.xml  { render :nothing => true }
    end
  end
end