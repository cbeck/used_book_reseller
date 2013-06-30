class AccountsController < ApplicationController
  before_filter :login_required
  skip_before_filter :find_cart, :only => [:new, :create]
  
  # GET /accounts
  # GET /accounts.xml
  #Changing this to be the hub for the member account. To view and edit accounts, use admin/accounts - coming soon :)
  def index
    @current_item = "my_account"
    
    respond_to do |format|
      format.html 
      format.xml  { render :xml => @accounts.to_xml }
    end
  end
  
  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @account.to_xml }
    end
  end
  
  # GET /accounts/new
  def new
    @no_tabs = true
    @no_links = true
    @account_types = AccountType.find(:all, :order => 'position ASC')
    @account_features = AccountFeature.find(:all, :order => 'position ASC')    
    @account = Account.new
  end
  
  # GET /accounts/1;edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    @account.member = current_member
    logger.info @account.inspect
    
    respond_to do |format|
      if @account.save
        flash[:notice] = 'Thanks for signing up!'        
        format.html { 
          redirect_back_or_default('/')
        }
        format.xml do
          headers["Location"] = account_url(@account)
          render :nothing => true, :status => "201 Created"
        end
      else
        flash[:notice] = 'There was a problem creating your account, but we can address that later. If you need to sell something right now, please contact support.'
        redirect_back_or_default('/')
        format.xml  { render :xml => @account.errors.to_xml }
      end
    end
  end
  
  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])
    
    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html { redirect_to account_url(@account) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account.errors.to_xml }        
      end
    end
  end
  
  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    
    respond_to do |format|
      format.html { redirect_to accounts_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  
end