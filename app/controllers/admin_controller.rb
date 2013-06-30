class AdminController < ApplicationController
  before_filter :login_required
  require_role :admin  
  
  def index
    @current_item = "admin"
  end
end
