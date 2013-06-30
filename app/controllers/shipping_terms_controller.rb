class ShippingTermsController < ApplicationController
  before_filter :login_required
  # GET /shipping_terms
  # GET /shipping_terms.xml
  def index
    @shipping_terms = ShippingTerm.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shipping_terms }
    end
  end

  # GET /shipping_terms/1
  # GET /shipping_terms/1.xml
  def show
    @shipping_term = ShippingTerm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shipping_term }
    end
  end

  # GET /shipping_terms/new
  # GET /shipping_terms/new.xml
  def new
    @shipping_term = ShippingTerm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shipping_term }
    end
  end

  # GET /shipping_terms/1/edit
  def edit
    @shipping_term = ShippingTerm.find(params[:id])
  end

  # POST /shipping_terms
  # POST /shipping_terms.xml
  def create
    @shipping_term = ShippingTerm.new(params[:shipping_term])

    respond_to do |format|
      if @shipping_term.save
        flash[:notice] = 'ShippingTerm was successfully created.'
        format.html { redirect_to(@shipping_term) }
        format.xml  { render :xml => @shipping_term, :status => :created, :location => @shipping_term }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shipping_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_terms/1
  # PUT /shipping_terms/1.xml
  def update
    @shipping_term = ShippingTerm.find(params[:id])

    respond_to do |format|
      if @shipping_term.update_attributes(params[:shipping_term])
        flash[:notice] = 'ShippingTerm was successfully updated.'
        format.html { redirect_to(@shipping_term) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shipping_term.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_terms/1
  # DELETE /shipping_terms/1.xml
  def destroy
    @shipping_term = ShippingTerm.find(params[:id])
    @shipping_term.destroy

    respond_to do |format|
      format.html { redirect_to(shipping_terms_url) }
      format.xml  { head :ok }
    end
  end
end
