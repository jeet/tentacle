# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  require 'redcloth'
  include AuthenticatedSystem
  include CacheableFlash

  before_filter :find_group
  helper_method  :group
  attr_reader    :group
  
  def find_group
    @group ||= Group.find(:first)
  end
end
