require File.dirname(__FILE__) + '/../test_helper'
require 'dashboard_controller'

# Re-raise errors caught by the controller.
class DashboardController; def rescue_action(e) raise e end; end

context "Dashboard Controller" do
  setup do
    @old        = Tentacle.domain
    @controller = DashboardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  teardown do
    Tentacle.domain = @old
  end
end
