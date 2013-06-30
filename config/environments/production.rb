# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# require 'syslog_logger'
# config.logger = SyslogLogger.new("hsa")

config.after_initialize do
  # ActiveMerchant::Billing::Base.mode = :production
  # OrderTransaction.gateway = ActiveMerchant::Billing::BraintreeGateway.new(
  #   :login => 'LIVE_LOGIN',
  #   :password => 'LIVE_PASSWORD'
  # )
  
  # ActionMailer::Base.default_url_options[:host] = 'hsa.local'      

  # Exemplar: set payment credentials
  # Payment.gateway_login =  ""
  # Payment.gateway_trans_key =  ""
  
  # Location.google_map_key = ""
  #  Location.geocoder = GoogleGeocode.new(Location.google_map_key)
end

# MEMCACHE_SERVERS = [ 'ec2-75-101-247-167.compute-1.amazonaws.com:11211']

USE_SSL=true
