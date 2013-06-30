class ForumGroupsController < ApplicationController
  before_filter :login_required
  # GET /forum_groups
  # GET /forum_groups.xml
  def index
    @forum_groups = ForumGroup.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @forum_groups.to_xml }
    end
  end

  # GET /forum_groups/1
  # GET /forum_groups/1.xml
  def show
    @forum_group = ForumGroup.find(params[:id])
    @forums = @forum_group.forums.find(:all, 
      :conditions => ['enabled = ?', true])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @forum_group.to_xml }
    end
  end

  # GET /forum_groups/new
  def new
    @forum_group = ForumGroup.new
  end

  # GET /forum_groups/1;edit
  def edit
    @forum_group = ForumGroup.find(params[:id])
  end

  # POST /forum_groups
  # POST /forum_groups.xml
  def create
    @forum_group = ForumGroup.new(params[:forum_group])

    respond_to do |format|
      if @forum_group.save
        flash[:notice] = 'ForumGroup was successfully created.'
        format.html { redirect_to forum_group_url(@forum_group) }
        format.xml  { head :created, :location => forum_group_url(@forum_group) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_group.errors.to_xml }
      end
    end
  end

  # PUT /forum_groups/1
  # PUT /forum_groups/1.xml
  def update
    @forum_group = ForumGroup.find(params[:id])

    respond_to do |format|
      if @forum_group.update_attributes(params[:forum_group])
        flash[:notice] = 'ForumGroup was successfully updated.'
        format.html { redirect_to forum_group_url(@forum_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_group.errors.to_xml }
      end
    end
  end

  # DELETE /forum_groups/1
  # DELETE /forum_groups/1.xml
  def destroy
    @forum_group = ForumGroup.find(params[:id])
    @forum_group.destroy

    respond_to do |format|
      format.html { redirect_to forum_groups_url }
      format.xml  { head :ok }
    end
  end
end
