# Include hook code here

Rails.plugin_routes << :tentacled_beast

$stderr.puts "init.rb"
Dir["#{File.dirname(__FILE__)}/lib/initializers/*.rb"].each do |f|
  $stderr.puts "Requiring #{f}"
  require f
end

# Some models have to be forcefully required
# because of namespace type clashes
require File.dirname(__FILE__) + "/app/models/group"
require File.dirname(__FILE__) + "/app/models/profile"

module Tentacle::Application::ForumMethods
  
  def self.included(base)
    $stderr.puts "Set forum sidebar"
    base.before_filter :set_forums_sidebar
    base.append_before_filter :set_group_forum_link
    base.helper_method :current_group
    base.helper_method :current_member
    base.helper_method :current_page
  end
  
  def set_forums_sidebar
    @content_for_sidebar ||= ""
    @content_for_sidebar += "<p>Forums plugin installed. <a href='/forums'>Go to forums</a></p>"
  end
  
  def set_group_forum_link
    @content_for_group_show ||= ""
    if @group or current_group
      @content_for_group_show << render_to_string(:partial => "groups/forums") unless RAILS_ENV=='test'
    end
  end

  def current_member
    return Membership.join_from(current_group.id, current_profile.id)
  end

  def current_group
    logger.warn "CURRENT GROUP!!"
    @group ||= Group.find_by_name((params[:group_id] || "Default").titleize) || Group.find(:first)
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

end