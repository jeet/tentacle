# Include hook code here

Dependencies.load_once_paths.delete lib_path
Rails.plugin_routes << :groups

Profile.has_many :memberships

# Some models have to be forcefully required
require File.dirname(__FILE__) + "/app/models/group"

module Tentacle::Application::GroupMethods
  
  def self.included(base)
    base.before_filter :set_groups_sidebar
    base.helper_method :current_group
    base.helper_method :current_page
  end
  
  def set_groups_sidebar
    @content_for_sidebar ||= ""
    @content_for_sidebar += "<p>Groups plugin installed. <a href='/groups'>Go to groups</a></p>"
  end

  def current_group
    @current_group ||= Group.find_by_name("Default") || Group.find(:first)
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

end