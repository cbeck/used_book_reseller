class Admin::PublishersController < ApplicationController
  
  # GET /publishers
  # GET /publishers.xml
  def index
    @publishers = Publisher.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @publishers.to_xml }
    end
  end
  
  # GET /publishers/1
  # GET /publishers/1.xml
  def show
    @publisher = Publisher.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @publisher.to_xml }
    end
  end
  
  # GET /publishers/new
  def new
    @publisher = Publisher.new
    
    respond_to do |format|
      format.html # new.rhtml
      format.js # new.rjs
    end
  end
  
  # GET /publishers/1;edit
  def edit
    @publisher = Publisher.find(params[:id])
  end

  # POST /publishers
  # POST /publishers.xml
  def create
    @publisher = Publisher.new(params[:publisher])
    
    respond_to do |format|
      if @publisher.save
        flash[:notice] = 'Publisher was successfully created.'
        
        format.html { redirect_to [:admin, @publisher] }
        format.xml do
          headers["Location"] = [:admin, @publisher]
          render :nothing => true, :status => "201 Created"
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @publisher.errors.to_xml }
      end
    end
  end
  
  # PUT /publishers/1
  # PUT /publishers/1.xml
  def update
    @publisher = Publisher.find(params[:id])
    
    respond_to do |format|
      if @publisher.update_attributes(params[:publisher])
        format.html { redirect_to [:admin, @publisher] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @publisher.errors.to_xml }        
      end
    end
  end
  
  # DELETE /publishers/1
  # DELETE /publishers/1.xml
  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_publishers_url   }
      format.xml  { render :nothing => true }
    end
  end
end