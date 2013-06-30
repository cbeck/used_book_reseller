class AvatarsController < ApplicationController
  before_filter :find_avatar, :except => [:new, :index, :create]
  # GET /avatars
  # GET /avatars.xml
  def index
    @avatars = Avatar.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @avatars }
    end
  end

  
  # GET /avatars/new
  # GET /avatars/new.xml
  def new
    @avatar = Avatar.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @avatar }
    end
  end


  # POST /avatars
  # POST /avatars.xml
  def create
    @avatar = Avatar.new(params[:avatar])
    @avatar.member = current_member
    
    respond_to do |format|
      if @avatar.save
        flash[:notice] = 'Your Avatar was successfully uploaded.'
        format.html { redirect_to member_profiles_url(current_member) }
        format.xml  { render :xml => @avatar, :status => :created, :location => @avatar }
      else
        flash[:notice] = 'This Avatar did not pass validation.'
        format.html { render :action => "new" }
        format.xml  { render :xml => @avatar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /avatars/1
  # PUT /avatars/1.xml
  def update
    
    respond_to do |format|
      if @avatar.update_attributes(params[:avatar])
        flash[:notice] = 'Avatar was successfully updated.'
        format.html { redirect_to member_profiles_url(current_member) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @avatar.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /avatars/1
  # DELETE /avatars/1.xml
  def destroy
    @avatar.destroy

    respond_to do |format|
      format.html { redirect_to member_profiles_url(current_member) }
      format.xml  { head :ok }
    end
  end
  
  protected 
  
  def find_avatar
    @avatar = Avatar.find(params[:id])
  end
end
