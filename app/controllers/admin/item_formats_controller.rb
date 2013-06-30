class Admin::ItemFormatsController < ApplicationController
  before_filter :login_required
	require_role :admin
  
  # GET /item_formats
  # GET /item_formats.xml
  def index
    @item_formats = ItemFormat.find(:all, :order => 'position ASC')

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @item_formats.to_xml }
    end
  end
  
  # GET /item_formats/1
  # GET /item_formats/1.xml
  def show
    @item_format = ItemFormat.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @item_format.to_xml }
    end
  end
  
  # GET /item_formats/new
  def new
    @item_format = ItemFormat.new
  end
  
  # GET /item_formats/1;edit
  def edit
    @item_format = ItemFormat.find(params[:id])
  end

  # POST /item_formats
  # POST /item_formats.xml
  def create
    @item_format = ItemFormat.new(params[:item_format])
    
    respond_to do |format|
      if @item_format.save
        flash[:notice] = 'ItemFormat was successfully created.'
        
        format.html { redirect_to [:admin, @item_format] }
        format.xml do
          headers["Location"] = [:admin, @item_format]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_format.errors.to_xml }
      end
    end
  end
  
  # PUT /item_formats/1
  # PUT /item_formats/1.xml
  def update
    @item_format = ItemFormat.find(params[:id])
    
    respond_to do |format|
      if @item_format.update_attributes(params[:item_format])
        format.html { redirect_to [:admin, @item_format] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_format.errors.to_xml }        
      end
    end
  end
  
  # DELETE /item_formats/1
  # DELETE /item_formats/1.xml
  def destroy
    @item_format = ItemFormat.find(params[:id])
    @item_format.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_item_formats_url   }
      format.xml  { render :nothing => true }
    end
  end
  
  def sort
    item_formats = ItemFormat.all
    unless item_formats.nil?      
      item_formats.each do |item|
        item.position = params['item_formats'].index(item.id.to_s) + 1
        item.save
      end
    end
    render :nothing => true
  end
end