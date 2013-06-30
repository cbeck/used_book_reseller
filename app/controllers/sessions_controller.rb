# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  #before_filter :activate_tab
  skip_before_filter :find_cart
  ssl_required :create, :new
  
  # render new.rhtml
  def new
    @logged_out = params[:logged_out]
    @hide_message = params[:nav]
    @order_id = params[:order_id]
  end

  def create
    logout_keeping_session!
    member = Member.authenticate(params[:login], params[:password])
    
    if member
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_member = member
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      unless params[:order_id].blank?
        order = Order.find(params[:order_id])
        unless order.blank?
          order.member = @member 
          order.save
        end
      end
      if request.xhr?
        render :partial => '/shared/logged_in'          
      else
        unless is_ie_6?
          flash[:notice] = "Welcome, #{member.login}!"
        end
        redirect_back_or_default('/')        
      end
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      flash[:notice] = "Couldn't log you in as '#{params[:login]}'"
      @order_id = params[:order_id]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out. Come back soon!"
    redirect_to new_session_path(:logged_out => true)
  end

protected
  # Track failed login attempts
  def note_failed_signin
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
  
private 

  def activate_tab
    @no_tabs = true
  end
end
