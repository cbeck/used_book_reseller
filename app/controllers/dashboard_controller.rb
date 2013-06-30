class DashboardController < ApplicationController
  before_filter :login_required
  
  def index
    @show_menu = true
    @unshipped_items = current_member.unshipped_items
    @incomplete_orders = current_member.incomplete_orders
  end
  
end
