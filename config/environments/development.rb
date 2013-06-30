# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
# config.action_view.cache_template_extensions         = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false


require 'ruby-debug'
require 'active_merchant'

# http://toolmantim.com/article/2006/12/27/environments_and_the_rails_initialisation_process
config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test 
  # ActionMailer::Base.default_url_options[:host] = 'hsa.local'    
end

config.to_prepare do
  OrderTransaction.gateway =
    ActiveMerchant::Billing::BraintreeGateway.new(
      :login => 'demo',
      :password => 'password'
    )
  
  # comment out the next line to enable maps
  #Location.google_map_key = nil
end

# MEMCACHE_SERVERS = [ '127.0.0.1:11211' ]
