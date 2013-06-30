class Admin::CategoriesController < ApplicationController
  before_filter :login_required
  require_role :admin
  
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.find(:all, :order => "name ASC")

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @categories.to_xml }
    end
  end
  
  # GET /categories/1
  # GET /categories/1.xml
  def show
    @category = Category.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @category.to_xml }
    end
  end
  
  # GET /categories/new
  def new
    @category = Category.new
  end
  
  # GET /categories/1;edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    
    respond_to do |format|
      if @category.save
        flash[:notice] = 'Category was successfully created.'
        
        format.html { redirect_to [:admin, @category] }
        format.xml do
          headers["Location"] = [:admin, @category]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors.to_xml }
      end
    end
  end
  
  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find(params[:id])
    
    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to [:admin, @category] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors.to_xml }        
      end
    end
  end
  
  # DELETE /categories/1
  # DELETE /categories/1.xml
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_categories_url   }
      format.xml  { render :nothing => true }
    end
  end
end