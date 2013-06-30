class FreecyclesController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :search]
  before_filter :activate_tab, :set_current_item
  before_filter :share_navigation
  
  self.allow_forgery_protection = false
  
  # GET /freecycles
  # GET /freecycles.xml
  def index
    @filter = params[:filter] || "id"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    @freecycles = Freecycle.paginate :page => params[:page], :order => filter
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @freecycles }
    end
  end
  
  def manage
    @filter = params[:filter] || "id"
    filter = (@filter != "id")? @filter.to_s + " ASC": @filter.to_s + " DESC"
    @freecycles = current_member.freecycles.paginate :page => params[:page], :order => filter
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @freecycles }
    end    
  end
  
  def search
   @filter = params[:filter] || "id"     
   freecycles = []
   @metro_area = MetroArea.find_by_name(params[:metro_area][:name]) unless params[:metro_area].blank?  
   if params[:commit] == "Search" || params[:q]         
     freecycles = (@metro_area) ? @metro_area.freecycles.find_by_contents(params[:q].to_s.upcase) : Freecycle.find_by_contents(params[:q].to_s.upcase)
   elsif params[:commit] == "Set"
     freecycles = @metro_area.freecycles unless @metro_area.blank?
   end
    @freecycles = (freecycles.blank?) ? freecycles : freecycles.sort_by {|f| (@filter == "id") ? -f.send(@filter) : f.send(@filter)}       
    unless @freecycles.size > 0
      flash.now[:notice] =  "Sorry! No items were found matching your criteria."
    end
  end
  
  def change_browser
    @partial = params[:to] || "metro_areas"
    @metro_area_name = params[:metro_area_name] || ""
  end

  # GET /freecycles/1
  # GET /freecycles/1.xml
  def show
    @freecycle = Freecycle.find(params[:id])
    @belongs_to_member = true if current_member.freecycles.include?(@freecycle)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @freecycle }
    end
  end

  # GET /freecycles/new
  # GET /freecycles/new.xml
  def new
    @freecycle = Freecycle.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @freecycle }
    end
  end

  # GET /freecycles/1/edit
  def edit
    @freecycle = current_member.freecycles.find(params[:id])
  end

  # POST /freecycles
  # POST /freecycles.xml
  def create
    @freecycle = Freecycle.new(params[:freecycle])
    @freecycle.metro_area = MetroArea.find_or_create_by_name(params[:metro_area][:name])
    @freecycle.member = current_member

    respond_to do |format|
      if @freecycle.save
        flash[:notice] = 'Awesome. Your Freecycle item was susccessfully posted.'
        format.html { redirect_to(@freecycle) }
        format.xml  { render :xml => @freecycle, :status => :created, :location => @freecycle }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @freecycle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /freecycles/1
  # PUT /freecycles/1.xml
  def update
    @freecycle = current_member.freecycles.find(params[:id])
    @freecycle.metro_area = MetroArea.find_or_create_by_name(params[:metro_area][:name]) unless params[:metro_area][:name].blank?

    respond_to do |format|
      if @freecycle.update_attributes(params[:freecycle])
        flash[:notice] = 'That Freecycle was successfully updated.'
        format.html { redirect_to(@freecycle) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @freecycle.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /freecycles/1
  # DELETE /freecycles/1.xml
  def destroy
    @freecycle = current_member.freecycles.find(params[:id])
    @freecycle.destroy

    respond_to do |format|
      flash[:notice] = "That Freecycle is outta here!"
      format.html { redirect_to(manage_freecycles_url) }
      format.js 
      format.xml  { head :ok }
    end
  end
  
  auto_complete_for :metro_area, :name
  
  private
  
  def activate_tab
    @active_tab = "share_tab"
  end
  
  def set_current_item
    @current_item = "freecycle"
  end
end
