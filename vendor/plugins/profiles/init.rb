# Include hook code here

Rails.plugin_routes << :profiles
Dependencies.load_once_paths.delete File.dirname(__FILE__)

require File.dirname(__FILE__) + "/app/models/profile"

module UserMethods
  def setup_profile
    Profile.create!(:first_name => 'Your', :last_name => 'Name', :user_id => id, :email => (login || 'you') + '@' + (identity_url || 'example.com'))
  end
end

User.has_one :profile
User.after_create :setup_profile
User.send(:include, UserMethods)

module Tentacle::Application::ProfileMethods
  
  def self.included(base)
    base.before_filter :set_profiles_sidebar
    base.helper_method :current_profile
  end
  
  def set_profiles_sidebar
    @content_for_sidebar ||= ""
    @content_for_sidebar += "<p>Profiles plugin installed. <a href='/profiles/me'>Go to your profile</a></p>"
  end

  def current_profile
    @current_profile ||= (current_user && current_user.profile)
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

end