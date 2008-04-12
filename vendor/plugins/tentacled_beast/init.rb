# Include hook code here

Rails.plugin_routes << :tentacled_beast

## these don't load from initializers, yet!?!?!?
## WTF!
class ActiveRecord::Base
  @@white_list_sanitizer = HTML::WhiteListSanitizer.new
  class << self
    attr_accessor :formatted_attributes
  end

  cattr_reader :white_list_sanitizer

  def self.formats_attributes(*attributes)
    (self.formatted_attributes ||= []).push *attributes
    before_save :format_attributes
    send :include, HtmlFormatting, ActionView::Helpers::TagHelper, ActionView::Helpers::TextHelper
  end

  def self.paginated_each(options = {}, &block)
    page = 1
    records = [nil]
    until records.empty? do 
      records = paginate(options.update(:page => page, :count => {:select => '*'}))
      records.each &block
      page += 1
    end
  end
end

class << ActiveRecord::Base
  def concerned_with(*concerns)
    concerns.each { |c| require_dependency "#{name.underscore}/#{c}" }
  end
end
########


# Some models have to be forcefully required
# because of namespace type clashes
require File.dirname(__FILE__) + "/app/models/group"
require File.dirname(__FILE__) + "/app/models/profile"

module Tentacle::Application::ForumMethods
  
  def self.included(base)
    $stderr.puts "Set forum sidebar"
    base.before_filter :set_forums_sidebar
    base.helper_method :current_group
    base.helper_method :current_page
  end
  
  def set_forums_sidebar
    $stderr.puts "Set forum sidebar"
    @content_for_sidebar ||= ""
    @content_for_sidebar += "<p>Forums plugin installed. <a href='/forums'>Go to forums</a></p>"
  end

  def current_group
    @current_group ||= Group.find_by_name("Default") || Group.find(:first)
  end

  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end

end