# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Authorization plugin - says to put this at top but I will test putting at bottom later
AUTHORIZATION_MIXIN = 'object roles'
DEFAULT_REDIRECTION_HASH = { :controller => 'site', :action => 'index' }
STORE_LOCATION_METHOD = :store_location


# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Dependencies
  # see: http://ryandaigle.com/articles/2008/4/1/what-s-new-in-edge-rails-gem-dependencies
  
  # these are getting out of hand - unless there is some functionality change that REQUIRES
  # me to upgrade, stop doing this. I had to upgrade 5 gems, and it never could sort out 
  # aaap properly, even though i got it from github just fine. pita.
  config.gem "amazon-ecs", :lib => 'amazon/ecs'
  config.gem "rmagick", :lib => 'RMagick'
  config.gem "acts_as_ferret", :version => "0.4.3"
  config.gem "SyslogLogger", :version => "1.4.0", :lib => 'syslog_logger'
  config.gem "memcache-client", :version => "1.5.0", :lib => 'memcache'
  config.gem "rubyist-aasm", :version => "2.0.5", :lib => "aasm", :source => "http://gems.github.com"
  config.gem "netphase-acts_as_amazon_product", :version => "2.1.1", :lib => "acts_as_amazon_product", :source => "http://gems.github.com"
  config.gem "activemerchant", :lib => 'active_merchant'
  config.gem "money", :version => "2.1.3  "
  config.gem "yfactorial-utility_scopes", :lib => 'utility_scopes', :source => 'http://gems.github.com/'
  config.gem "RedCloth", :version => "4.1.9"
  config.gem "mislav-will_paginate", :version => "2.3.7", :lib => 'will_paginate', :source => 'http://gems.github.com/'

  # config.gem "acts_as_paranoid", :version => "0.3.1"
  # config.gem "rspec-rails", :version => "1.1.11", :lib => 'spec/rails'
  # config.gem "fastercsv", :version => "1.2.3"
  # config.gem "google-geocode", :lib => 'google_geocode'
  # config.gem "rails_analyzer_tools", :version => "1.4.0"
  # config.gem "production_log_analyzer", :version => "1.5.0"

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_hsa_session',
    :secret      => '5162aee5fe6d90f9c6c5916068ef0b7104ef2e7907eab44d23305372182075a3359770785480f76afdc4876388e8ce731377da24624f14a4dc9d06eb5a044188'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store
  # config.action_controller.session_store = :mem_cache_store

  # config.action_controller.cache_store = :mem_cache_store, memcache_servers, memcache_options

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :member_observer, :payment_notification_observer

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  FILE_STORE_PATH = File.join(RAILS_ROOT, "/public/cache/")
  config.action_controller.page_cache_directory = FILE_STORE_PATH
  config.action_controller.cache_store = :file_store, FILE_STORE_PATH
  
end

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
  #inflect.uncountable %w(  )
# end

# Include your application configuration below
# Comatose.configure do |comatose|
#   comatose.includes << :authenticated_system
#   comatose.helpers <<  :application_helper
#   # admin
#   comatose.admin_title = "#{SITE_NAME} Article Managment"
#   comatose.admin_sub_title = "... its' fun for the whole family!"      
#   comatose.admin_includes << :authenticated_system
#   comatose.admin_helpers << :application_helper
#   #comatose.admin_authorization = :admin_required
#   comatose.admin_authorization = :login_required
#   comatose.default_tree_level = 3
#   comatose.admin_get_author do
#     current_user.login
#   end
#   # this is what i need to change to get the proper page to load...
#   #comatose.admin_get_root_page do
#    # roots = %w( public-root content-fragments)
#    # roots.collect {|path| Comatose::Page.find_by_path(path)}
# end

raw_config = File.read(RAILS_ROOT + "/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[RAILS_ENV].symbolize_keys

ActionMailer::Base.default_url_options[:host] = APP_CONFIG[:domain]

require 'rails_extensions'
# require 'acts_as_ferret'

# cache_params = *([MEMCACHE_SERVERS, MEMCACHE_OPTIONS].flatten)
# CACHE = MemCache.new *cache_params
# ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })


WillPaginate.enable_named_scope

IMAGE_NOT_AVAIL = '/images/hsa_button_only_75.png'
MED_IMAGE_NOT_AVAIL = '/images/hsa_button_only_256.png'
LARGE_IMAGE_NOT_AVAIL = '/images/hsa_button_only_256.png'

SITE_NAME = 'HSA'
SITE_USERS = 'members'
