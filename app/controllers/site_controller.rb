class SiteController < ApplicationController
  before_filter :activate_tab, :only => [:index, :how, :faq]
  before_filter :home_navigation, :only => [:index, :how, :faq]
  before_filter :shop_navigation, :only => [:search, :wishlist]
  #skip_before_filter :login_required, :only => [:index, :how, :faq, :privacy, :terms, :press, :contact, :about]
  
   def index
     redirect_to disabled_path
     # unless logged_in?
     #        redirect_to tour_path
     #      else
     #        @current_item = "my_hsa"
     #      end
   end
   
   def search
     @active_tab = "shop_tab"
     @current_item = "find_products"
     @products = []
     @filter = params[:filter] || "id"     
     if params[:commit] == "Search" || params[:q]
       products = Product.available.find_by_contents(params[:q].to_s.upcase)
       @products = (products.blank?) ? products : products.sort_by {|p| (@filter == "id") ? -p.send(@filter) : p.send(@filter)}       
       unless @products.size > 0
         flash.now[:notice] =  "Sorry! No products were found matching your criteria."
       end       
     end
   end
  
   def interact
     @active_tab = "interact_tab"
   end  
   
   def share
      @active_tab = "share_tab"
      share_navigation
   end
   
   def wishlist
     @active_tab = "shop_tab"
     @current_item = "wishlist"
   end
   
   def how
     @current_item = "how_does_this_work?"
   end
   
   def faq
     @current_item = "faq"
   end
   
   private
   
   def activate_tab
     @active_tab = "home_tab"
   end
   
   
end
