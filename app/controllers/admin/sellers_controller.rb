class Admin::SellersController < ApplicationController
  before_filter :login_required
  # GET /sellers
  # GET /sellers.xml
  def index 
    #leave this in place for future - currently allowing only one seller per user   
    @seller = self.current_member.seller
    respond_to do |format|
      if @seller.nil?
        format.html { redirect_to new_member_seller_url(self.current_member) }
      else
        format.html { redirect_to member_seller_url(current_member, @seller)}
        format.xml  { render :xml => @sellers.to_xml }
      end
    end
  end
  
  # GET /sellers/1
  # GET /sellers/1.xml
  def show
    @seller = Seller.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @seller.to_xml }
    end
  end
  
  # GET /sellers/new
  def new
    @seller = Seller.new
  end
  

  # POST /sellers
  # POST /sellers.xml
  def create
    @seller = Seller.new(params[:seller])
    @seller.member = self.current_member
    respond_to do |format|
      if @seller.save
        flash[:notice] = 'Your store account was successfully created.  Happy selling!'      
        format.html { redirect_back_or_default(:controller => 'dashboard', :action => 'index')  }
        format.xml do
          headers["Location"] = member_seller_url(@member, @seller)
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @seller.errors.to_xml }
      end
    end
  end
  
  # PUT /sellers/1
  # PUT /sellers/1.xml
  def update
    @seller = Seller.find(params[:id])
    
    respond_to do |format|
      if @seller.update_attributes(params[:seller])
        format.html { redirect_to seller_url(@seller) }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @seller.errors.to_xml }        
      end
    end
  end
  
  # DELETE /sellers/1
  # DELETE /sellers/1.xml
  def destroy
    @seller = Seller.find(params[:id])
    @seller.destroy
    
    respond_to do |format|
      format.html { redirect_to sellers_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  # GET /sellers/1;feedback
  # GET /sellers/1.xml;feedback
  # gets feedback left for this seller
  def feedback
    @seller = Seller.find(params[:id])
    @feedback = @seller.feedback.find(:all)
    
    respond_to do |format|
      format.html # feedback.rhtml
      format.xml  { render :xml => @feedback.to_xml }
    end
  end
end