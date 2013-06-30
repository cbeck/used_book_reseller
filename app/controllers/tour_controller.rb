class TourController < ApplicationController
  before_filter :activate_tab
  
  def index
    if logged_in?
      find_cart
      home_navigation
      @current_item = "tour"
    else
      tour_navigation
      @current_item = "tour"
    end
  end
  
  
  private 

  def activate_tab
    @active_tab = "home_tab"
  end
end
