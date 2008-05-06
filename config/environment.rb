require 'ostruct'

# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Set this to :path to have URLs like http://my-tentacle.com/repo1/* instead of 
# http://repo1.my-tentacle.com/*
# USE_REPO_PATHS = true

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

# Allow us to define routes in plugins
Rails.mattr_accessor :plugin_routes
Rails.plugin_routes = []

# Configuration for external services like S3, Akismet, etc.
Rails.mattr_accessor :service_data
Rails.service_data = OpenStruct.new
  
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here
  
  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :active_resource, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/concerns #{RAILS_ROOT}/app/cachers )
  
  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  config.action_controller.session = {
    :session_key => '_tentacle_session',
    :secret      => '4b3eaf64bfa62da140e0f45c9030f272'
  }

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options
  
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory is automatically loaded
  
  
  # Load Enginized models and all the other engine code we use.  Otherwise it won't load models
  # and other code won't reload.
  config.to_prepare do
    Dir.glob("#{RAILS_ROOT}/vendor/plugins/**/app/**/*.rb").each do |code_file|
      load code_file
    end
  end
end