class MembersController < ApplicationController
  ssl_required :create, :new, :edit, :update
  ssl_allowed :forgot_password, :reset_password, :initiate_reset
  
  before_filter :login_required, :except => [:new, :create]
  skip_before_filter :find_cart, :except => [:show, :edit, :update]
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_member, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :only => [:follow, :unfollow]
  before_filter :show_menu, :except => [:new]
  
  # render new.rhtml
  def new
    @member = Member.new
    @order_id = params[:order_id]
  end
 
  def create
    logout_keeping_session!
    @member = Member.new(params[:member])
    success = @member && @member.valid?
    @member.register! if success
    @member.activate! if success
    account_type = AccountType.free_account
    @account = @member.create_account(:account_type => account_type)
    self.current_member = @member

    if success && @member.errors.empty?
      unless params[:order_id].blank?
        order = Order.find(params[:order_id])
        unless order.blank?
          order.member = @member 
          order.save
        end
      end
      if @account.nil?
        redirect_to new_account_url
      else
        redirect_back_or_default('/')
      end
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      @order_id = params[:order_id]
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    @member = current_member
    
    respond_to do |format|
      if @member.update_attributes(params[:member])
        flash[:notice] = 'Member was successfully updated.'
        # @member.reset_password if logged_in? && !@member.password_reset_code.nil?

        format.html { redirect_to(member_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @member.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reset_password
    self.current_member = Member.find_by_password_reset_code(params[:password_reset_code])
    flash[:notice] = "You have been logged in. You must now reset your password!"
    redirect_to(account_url)
  end
  
  def initiate_reset
    if reset_attempt <= 30
      q = params[:email]
      member = Member.find_by_email(q)
      if member.nil?
        flash[:notice] = "Member #{q} was not found.  (#{reset_attempt.ordinalize} reset attempt)"
        redirect_to(forgot_password_path)
      else
        member.forgot_password
        flash[:notice] = "An activation link has been sent to #{member.email}."
        redirect_to(login_path)
      end
    else
      flash[:notice] = "Too many reset attempts"
      redirect_to(signup_path)
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
    redirect_to members_path
  end

  def unsuspend
    @member.unsuspend! 
    redirect_to members_path
  end

  def destroy
    @member.delete!
    redirect_to members_path
  end

  def purge
    @member.destroy
    redirect_to members_path
  end
  
  def feedback
    @member = Member.find(params[:id])
    @feedback = @member.feedback.find(:all)
    
    respond_to do |format|
      format.html # feedback.rhtml
      format.xml  { render :xml => @feedback.to_xml }
    end
  end
  
  def follow
    @following = Member.find(params[:id])
    unless current_member.followings.include? @following
      current_member.followings << @following
    end
    respond_to do |format|
      format.html {redirect_to profile_path(@following.login)}
      format.js  { render :partial => "/shared/follow", :locals => {:member => @following}   }
    end    
  end
  
  def unfollow
    @following = Member.find(params[:id])
    if current_member.followings.include? @following
      current_member.followings.delete @following
    end
    respond_to do |format|
      format.html {redirect_to profile_path(@following.login)}
      format.js  { render :partial => "/shared/follow", :locals => {:member => @following}   }
    end   
  end
  
  # There's no page here to update or destroy a member.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_member
    @member = Member.find(params[:id])
  end
  
  def reset_attempt
    if @reset_attempts.nil?
      session['reset_attempt'] ||= 0
      @reset_attempts = session['reset_attempt'] += 1
    end
    @reset_attempts
  end
end
