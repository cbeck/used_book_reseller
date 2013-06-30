ActionController::Routing::Routes.draw do |map|

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'members', :action => 'create'
  map.signup '/signup', :controller => 'members', :action => 'new'
  map.account '/account', :controller => 'accounts', :action => 'index'
  map.activate '/activate/:activation_code', :controller => 'members', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'members', :action => 'forgot_password'
  map.initiate_reset '/initiate_reset', :controller => 'members', :action => 'initiate_reset'
  map.reset_password '/reset_password/:password_reset_code', :controller => 'members', :action => 'reset_password'
  
  map.my_unshipped_items '/my_unshipped_items', :controller => 'line_items', :action => 'unshipped'
  
  map.admin '/admin', :controller => 'admin', :action => 'index'
  map.profile '/profile/:screen_name', :controller => 'profiles', :action => 'public_profile', :screen_name => nil
  map.shop '/shop', :controller => 'categories', :action => 'index'
  
  map.with_options :controller => 'help' do |m|
    m.textile_explanation '/textile',:action => 'textile'
    m.isbn_explanation '/isbn', :action => 'isbn'
    m.shipping_explanation '/shipping', :action => 'shipping'
    m.selling_explanation '/selling', :action => 'selling'
  end
  
  map.with_options :controller => 'tour' do |m|
    m.tour '/tour', :action => 'index'
    m.disabled '/be_right_back', :action => 'disabled'
  end
  
  map.with_options :controller => 'site' do |m|
    m.home '/home',:action => 'index'
    m.search '/search', :action => 'search'
    m.interact '/interact', :action => 'interact'
    m.share '/share', :action => 'share'
    m.press '/press', :action => 'press'
    m.privacy '/privacy', :action => 'privacy'
    m.terms '/terms', :action => 'terms'
    m.about '/about', :action => 'about'
    m.contact '/contact', :action => 'contact'
    m.wishlist '/wishlist', :action => 'wishlist'
    m.how '/how_does_this_work', :action => 'how'
    m.faq '/faq', :action => 'faq'
  end
 
  
  map.thank_you '/thank_you', :controller => 'orders', :action => 'thank_you'
  
  map.namespace :admin do |admin|
    admin.resources :account_features, :collection=> { :sort => :post }
    admin.resources :account_types, :collection=> { :sort => :post }
    admin.resources :categories  
    admin.resources :publishers
    admin.resources :item_formats, :collection=> { :sort => :post }
    admin.resources :orders 
    admin.resources :payment_types
    admin.resources :roles
    admin.resources :shipping_terms    
    admin.resources :conditions
    admin.resources :members, :member => { 
        :feedback => :get, 
        :suspend => :put, 
        :unsuspend => :put, 
        :purge => :delete  } do |ad_member|
      ad_member.resources :sellers, :member => { :feedback => :get }
		end  
		admin.resources :sellers
		admin.resources :statuses  
  end
  
  # map.with_options :controller => 'site' do |m|
  #    m.search '/site/search', :action => 'search'
  #  end
  
  map.resources :members, 
    :member => { 
      :feedback => :get,
      :suspend => :put, 
      :unsuspend => :put, 
      :purge => :delete, 
      :follow => :post, 
      :unfollow => :post  } do |member|
    member.resources :sellers, :member => {:feedback => :get}
    member.resources :profiles
    member.resources :avatars, :member => {:show_thumb => :get, :show_tiny => :get} 
  end
  map.resources :sellers, :member => {:feedback => :get, :profile => :get}
  map.resources :feedbacks
  map.resources :ratings
  map.resources :product_reviews
  map.resources :forum_groups
  map.resources :forums do |forums|
    map.resources :forum_posts, :member => { :reply => :get }
  end
  map.resources :products, :member => {:detail => :get, :toggle_status => :post, :sort_product_images => :post, :toggle_default_image => :post} do |products|
    products.resources :product_images, :member => {:show_full => :get, :show_thumb => :get, :show_featured => :get}
    products.resources :line_items
  end    
  # map.resources :carts
  map.resources :orders, :member => {:complete => :get, :cancel => :get }
  map.resources :line_items, :member => {:buyer => :get}, :collection => {:unshipped => :get, :needs_feedback => :get}
 
  map.resources :accounts 
  map.resources :sessions 
  map.resources :categories, :collection=> {:change_browser => :post} 
  map.resources :carriers
  map.resources :freecycles, :collection=> {:search => :get, :change_browser => :post, :manage => :get}
  map.resources :metro_areas
  map.resources :media_mails
  map.resources :payment_notifications
  map.resources :messages
   
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "site", :action => 'index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  # map.comatose_admin
  # map.comatose_root 'pages'
  # map.comatose_root ''
  
end
