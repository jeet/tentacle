# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'e125a4be589f9d81263920581f6e4182'
  
  def current_page
    @page ||= params[:page].blank? ? 1 : params[:page].to_i
  end
  
  def current_group
    @current_group ||= Group.find_by_name("Default")
  end
end
