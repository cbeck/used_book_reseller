class MetroAreasController < ApplicationController
  before_filter :login_required
  # GET /metro_areas
  # GET /metro_areas.xml
  def index
    @metro_areas = MetroArea.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @metro_areas }
    end
  end

  # GET /metro_areas/1
  # GET /metro_areas/1.xml
  def show
    @metro_area = MetroArea.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @metro_area }
    end
  end

  # GET /metro_areas/new
  # GET /metro_areas/new.xml
  def new
    @metro_area = MetroArea.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @metro_area }
    end
  end

  # GET /metro_areas/1/edit
  def edit
    @metro_area = MetroArea.find(params[:id])
  end

  # POST /metro_areas
  # POST /metro_areas.xml
  def create
    @metro_area = MetroArea.new(params[:metro_area])

    respond_to do |format|
      if @metro_area.save
        flash[:notice] = 'MetroArea was successfully created.'
        format.html { redirect_to(@metro_area) }
        format.xml  { render :xml => @metro_area, :status => :created, :location => @metro_area }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @metro_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /metro_areas/1
  # PUT /metro_areas/1.xml
  def update
    @metro_area = MetroArea.find(params[:id])

    respond_to do |format|
      if @metro_area.update_attributes(params[:metro_area])
        flash[:notice] = 'MetroArea was successfully updated.'
        format.html { redirect_to(@metro_area) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @metro_area.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /metro_areas/1
  # DELETE /metro_areas/1.xml
  def destroy
    @metro_area = MetroArea.find(params[:id])
    @metro_area.destroy

    respond_to do |format|
      format.html { redirect_to(metro_areas_url) }
      format.xml  { head :ok }
    end
  end
end
