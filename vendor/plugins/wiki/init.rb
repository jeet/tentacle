# Include hook code here
require 'redcloth'

Rails.plugin_routes << :wiki
Dependencies.load_once_paths.delete File.dirname(__FILE__)

Rails.service_data.wiki = { :akismet_key => "", :askismet_url => "" }

require 'app/models/group'
Group.has_many :pages

Profile.can_flag
Profile.has_many :pages, :order => 'title ASC'

module Tentacle::Application::ForumMethods
  def self.included(base)
    $stderr.puts "Wiki setup"
    base.before_filter :find_group
    base.send(:attr_reader, :group)
    base.helper_method :group
  end
  
  def find_group
    @group ||= Group.find(:first)
  end
end