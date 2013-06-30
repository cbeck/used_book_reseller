class Admin::MembersController < ApplicationController
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_member, :only => [:suspend, :unsuspend, :destroy, :purge, :show, :edit, :feedback, :update]
  
  def index
    @members = Member.find(:all)
  end  
  
  def update
    
    respond_to do |format|
      if @member.update_attributes(params[:member])
        format.html { redirect_to [:admin, @member] }
        format.xml  { render :nothing => true }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors.to_xml }        
      end
    end
  end
 
  def activate
    logout_keeping_session!
    member = Member.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && member && !member.active?
      member.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a member with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @member.suspend! 
    redirect_to [:admin, @member]
  end

  def unsuspend
    @member.unsuspend! 
    redirect_to [:admin, @member]
  end

  def destroy
    @member.delete!
    redirect_to admin_members_path
  end

  def purge
    @member.destroy
    redirect_to admin_members_path
  end
  
  def feedback
    @feedback = @member.feedback.find(:all)
    
    respond_to do |format|
      format.html # feedback.rhtml
      format.xml  { render :xml => @feedback.to_xml }
    end
  end
  
  # There's no page here to update or destroy a member.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_member
    @member = Member.find(params[:id])
  end
end
