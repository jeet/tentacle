USE_REPO_PATHS  = ENV['USE_REPO_PATHS'] unless Object.const_defined?(:USE_REPO_PATHS)
REPO_ROOT_REGEX = /^(\/?(admin|install|login|logout|reset|forget))(\/|$)/

ActionController::Routing::Routes.draw do |map|
  map.connect ":asset/:plugin/*paths", :asset => /images|javascripts|stylesheets/, :controller => "assets", :action => "show"
  
  map.with_options :path_prefix => 'admin' do |admin|
    admin.resources :users
  end

  Rails.plugin_routes.each do |plugin|
    map.from_plugin plugin
  end
  
  map.with_options :controller => "sessions" do |s|
    s.login   "login",        :action => "create"
    s.logout  "logout",       :action => "destroy"
    s.forget  "forget",       :action => "forget"
    s.reset   "reset/:token", :action => "reset", :token => nil
  end

  map.admin    "admin",          :controller => "users"
  map.settings "admin/settings", :controller => "install", :action => "settings"

  map.installer "install", :controller => "install", :action => "index",   :conditions => { :method => :get  }
  map.connect   "install", :controller => "install", :action => "install", :conditions => { :method => :post }
  
  if RAILS_ENV == "development"
    map.connect "test_install", :controller => "install", :action => "test_install"
  end

  map.root :controller => "dashboard"
end