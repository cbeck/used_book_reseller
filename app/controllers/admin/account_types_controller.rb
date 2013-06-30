class Admin::AccountTypesController < ApplicationController
  before_filter :login_required
	require_role :admin
  
  # GET /account_types
  # GET /account_types.xml
  def index
    @account_types = AccountType.find(:all, :order => 'position ASC')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @account_types.to_xml }
    end
  end
  
  # GET /account_types/1
  # GET /account_types/1.xml
  def show
    @account_type = AccountType.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @account_type.to_xml }
    end
  end
  
  # GET /account_types/new
  def new
    @account_type = AccountType.new
  end
  
  # GET /account_types/1;edit
  def edit
    @account_type = AccountType.find(params[:id])
  end

  # POST /account_types
  # POST /account_types.xml
  def create
    @account_type = AccountType.new(params[:account_type])
    @account_type.price = params[:price].to_money unless params[:price].blank?
    @account_type.flat_fee = params[:flat_fee].to_money unless params[:flat_fee].blank?   
    
    respond_to do |format|
      if @account_type.save
        flash[:notice] = 'AccountType was successfully created.'
        
        format.html { redirect_to [:admin, @account_type] }
        format.xml do
          headers["Location"] = [:admin, @account_type]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_type.errors.to_xml }
      end
    end
  end
  
  # PUT /account_types/1
  # PUT /account_types/1.xml
  def update
    @account_type = AccountType.find(params[:id])
    @account_type.price = params[:price].to_money unless params[:price].blank?
    @account_type.flat_fee = params[:flat_fee].to_money unless params[:flat_fee].blank?   
    
    respond_to do |format|
      if @account_type.update_attributes(params[:account_type])
        format.html { redirect_to [:admin, @account_type] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_type.errors.to_xml }        
      end
    end
  end
  
  # DELETE /account_types/1
  # DELETE /account_types/1.xml
  def destroy
    @account_type = AccountType.find(params[:id])
    @account_type.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_account_types_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  def sort
    account_types = AccountType.all
    unless account_types.nil?      
      account_types.each do |acct_type|
        acct_type.position = params['account_types'].index(acct_type.id.to_s) + 1
        acct_type.save
      end
    end
    render :nothing => true
  end
end