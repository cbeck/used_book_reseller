class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  include AuthenticatedSystem
  include RoleRequirementSystem
  include SslRequirement
  
  skip_before_filter :ensure_proper_protocol if RAILS_ENV == "development" 
  
  layout 'hsa_app'    
  
  # "remember me" functionality
  # before_filter :login_from_cookie
  
  # See ActionController::RequestForgeryProtection for details
  protect_from_forgery
  
  before_filter :disable_links
  before_filter :find_cart
  # before_filter :find_featured
  
  filter_parameter_logging "password" 
  
  private 
  def find_cart
    if logged_in?
      @cart = Order.find :first, :conditions => ["member_id = ? and status = 'pending'", current_member.id]
      @cart = Order.create(:member_id => current_member.id) if @cart.nil?
      unless @cart.empty?
        flash[:notice] = 'Some of the items in your cart are no longer available' unless @cart.hold_all(current_member)
      end
    else
      session[:foo]   # lazy loading session patch.  see: http://bit.ly/1pvTLv
      session_id = request.session_options[:id]
      logger.info session_id
      @cart = Order.find :first, :conditions => ["session_id = ? and status = 'pending'", session_id]
      @cart = Order.create(:session_id => session_id) if @cart.nil?
    end    
  end
  
  def disable_links
    @no_tabs = true
    @no_links = true
    @cart = nil
  end
  
  def find_featured
    @featured = Product.featured
  end 
  
  def find_seller
    if logged_in?
      @seller = self.current_member.seller 
      if @seller.nil? 
        store_location 
        unless is_ie_6?
          flash[:notice] = 'Please enter the "Seller" information you would like presented to prospective buyers...'
        end        
        redirect_to new_member_seller_url(self.current_member)
      else
        return @seller
      end
    else
      redirect_to new_member_url  
    end
  end
  
  def show_menu
    @show_menu = true
  end
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :controller => 'site', :action => :index
  end 
  
  def home_navigation
    @sub_nav_items = [{"my hsa" => home_path}, {"tour" => tour_path}, {"how does this work?" => how_path}, {"faq" => faq_path}]
  end
  
  def tour_navigation
    @sub_nav_items = [{"tour" => tour_path}, {"start shopping now" => categories_path}]
  end
  
  def shop_navigation
    @sub_nav_items = [{"find products" => categories_path}, {"my purchases" => orders_path}, {"leave feedback" => needs_feedback_line_items_path}]
  end
  
  def sell_navigation
    @sub_nav_items = [{"my products" => products_path}, {"ship items" => unshipped_line_items_path}, {"my sales" => line_items_path}, {"my feedback" => feedbacks_path}]
  end
  
  def interact_navigation
    @sub_nav_items = [{"peeps" => home_path}, {"find members" => home_path}, {"write a product review" => home_path}, {"forum" => home_path}]
  end
  
  def share_navigation
    @sub_nav_items = [{"freecycle" => freecycles_path}]
  end
  
  def no_navigation
    @sub_nav_items = []
  end
  
  def is_ie_6?
    request.env['HTTP_USER_AGENT'].index('MSIE')
  end
  
  
end
