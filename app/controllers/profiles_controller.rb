class ProfilesController < ApplicationController
  before_filter :login_required
  before_filter :show_menu, :except => [:public_profile]
  # GET /sellers
  # GET /sellers.xml
  def index 
    @profile = self.current_member.profile
    respond_to do |format|
      if @profile.nil?
        format.html { redirect_to new_member_profile_url(self.current_member) }
      else
        format.html { redirect_to [self.current_member, @profile]}
      end
    end
  end

  # GET /profiles/1
  # GET /profiles/1.xml
  def show
    @profile = self.current_member.profile

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @profile.to_xml }
    end
  end
  
  def public_profile
    screen_name = params[:screen_name]
    member = Member.find_by_login(screen_name)
    @profile = member.profile if member.profile && member.profile.active?
    unless @profile
     flash[:notice] = "There is no publically viewable profile that matches your request."
     redirect_to home_url
   end
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
  end

  # GET /profiles/1;edit
  def edit
    @profile = self.current_member.profile
  end

  # POST /profiles
  # POST /profiles.xml
  def create
    @profile = Profile.new(params[:profile])
    @profile.member = self.current_member

    respond_to do |format|
      if @profile.save
        flash[:notice] = 'Profile was successfully created.'
        format.html { redirect_to [self.current_member, @profile] }
        format.xml  { head :created, :location => [self.current_member, @profile] }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @profile.errors.to_xml }
      end
    end
  end

  # PUT /profiles/1
  # PUT /profiles/1.xml
  def update
    @profile = self.current_member.profile

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        flash[:notice] = 'Profile was successfully updated.'
        format.html { redirect_to [self.current_member, @profile]  }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @profile.errors.to_xml }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.xml
  def destroy
    @profile = self.current_member.profile
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to current_member_profile_path }
      format.xml  { head :ok }
    end
  end
end
