class Admin::AccountFeaturesController < ApplicationController
  before_filter :login_required
	require_role :admin
  
  # GET /account_features
  # GET /account_features.xml
  def index
    @account_features = AccountFeature.find(:all, :order => 'position ASC')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @account_features.to_xml }
    end
  end
  
  # GET /account_features/1
  # GET /account_features/1.xml
  def show
    @account_feature = AccountFeature.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @account_feature.to_xml }
    end
  end
  
  # GET /account_features/new
  def new
    @account_feature = AccountFeature.new
  end
  
  # GET /account_features/1;edit
  def edit
    @account_feature = AccountFeature.find(params[:id])
  end

  # POST /account_features
  # POST /account_features.xml
  def create
    @account_feature = AccountFeature.new(params[:account_feature])
    
    respond_to do |format|
      if @account_feature.save
        flash[:notice] = 'AccountFeature was successfully created.'
        
        format.html { redirect_to [:admin, @account_feature] }
        format.xml do
          headers["Location"] = [:admin, @account_feature]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_feature.errors.to_xml }
      end
    end
  end
  
  # PUT /account_features/1
  # PUT /account_features/1.xml
  def update
    @account_feature = AccountFeature.find(params[:id])
    
    respond_to do |format|
      if @account_feature.update_attributes(params[:account_feature])
        format.html { redirect_to [:admin, @account_feature] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_feature.errors.to_xml }        
      end
    end
  end
  
  # DELETE /account_features/1
  # DELETE /account_features/1.xml
  def destroy
    @account_feature = AccountFeature.find(params[:id])
    @account_feature.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_account_features_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  def sort
    account_features = AccountFeature.all
    unless account_features.nil?      
      account_features.each do |acct_feat|
        acct_feat.position = params['account_features'].index(acct_feat.id.to_s) + 1
        acct_feat.save
      end
    end
    render :nothing => true
  end
end