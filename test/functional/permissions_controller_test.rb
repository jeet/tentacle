require File.dirname(__FILE__) + '/../test_helper'
require 'permissions_controller'

# Re-raise errors caught by the controller.
class PermissionsController; def rescue_action(e) raise e end; end

context "Permissions Controller" do
  def setup
    @controller = PermissionsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @controller.stubs(:current_user).returns(users(:rick))
    @request.host = "sample.test.host"
  end

  specify "should ask for basic authentication on text requests" do
    @controller.stubs(:current_repository).returns(repositories(:sample))
    @controller.stubs(:current_user).returns(nil)
    get :index, :format => 'text'
    assert_response 401
  end

  specify "should login with basic authentication on text requests" do
    @controller.stubs(:current_repository).returns(repositories(:sample))
    @controller.stubs(:current_user).returns(nil)
    @controller.expects(:authenticate_or_request_with_http_basic).yields(users(:rick).token, 'x').returns(users(:rick))
    get :index, :format => 'text'
    assert_response :success
  end

  specify "should grant new permission to repo" do
    assert_difference "Permission.count" do
      assert_difference "User.count" do
        post :create, :email => 'imagetic@wh.com', :permission => { :login => 'imagetic' }
        assert_template 'index'
      end
    end
    
    assigns(:user).should.not.be.new_record
    p = repositories(:sample).permissions.find_by_user_id(assigns(:user).id)
    p.login.should == 'imagetic'
    p.should.be.active
    p.should.not.be.admin
  end

  specify "should invite new member to repo" do
    assert_difference "Permission.count" do
      assert_no_difference "User.count" do
        post :create, :email => 'justin@wh.com', :permission => { :login => 'justin', :admin => true }
        assert_template 'index'
      end
    end
    
    assigns(:user).should.not.be.new_record
    p = repositories(:sample).permissions.find_by_user_id(assigns(:user).id)
    p.login.should == 'justin'
    p.should.be.active
    p.should.be.admin
    u = repositories(:sample).members.find_by_id(assigns(:user).id)
    u.should.be.permission_admin
  end

  specify "should grant exiting member mulitple paths" do
    assert_difference "Permission.count", 2 do
      assert_no_difference "User.count" do
        post :create, :email => 'justin@wh.com', :permission => { :login => 'justin', :admin => true, :paths => {'0' => {:path => 'foo'}, '1' => {:path => 'bar', :full_access => true}} }
        assert_template 'index'
      end
    end
    
    assigns(:user).should.not.be.new_record
    perms = repositories(:sample).permissions.find_all_by_user_id(assigns(:user).id).sort_by(&:path)
    perms[0].login.should == 'justin'
    perms[0].should.be.active
    perms[0].should.be.admin
    perms[0].path.should == 'bar'
    perms[0].should.be.full_access
    perms[1].login.should == 'justin'
    perms[1].should.be.active
    perms[1].should.be.admin
    perms[1].path.should == 'foo'
    perms[1].should.not.be.full_access
  end

  specify "should update user permission" do
    permissions(:rick_sample).should.be.admin
    permissions(:rick_sample).path.should.be.nil

    put :update, :user_id => 1, :permission => { :admin => false, :paths => {'0' => {:path => 'foo', :id => 1}} }
    assert_redirected_to permissions_path
    
    permissions(:rick_sample).reload.should.not.be.admin
    permissions(:rick_sample).path.should == 'foo'
  end
  
  specify "should update anon permission" do
    permissions(:anon_sample).reload.should.not.be.admin
    permissions(:anon_sample).reload.should.not.be.full_access
    
    put :anon, :permission => { :admin => true, :paths => {'0' => {:id => 2, :full_access => true}} }
    assert_redirected_to permissions_path
    
    permissions(:anon_sample).reload.should.be.admin
    permissions(:anon_sample).reload.should.be.full_access
  end

  specify "should not invite new user with invalid email" do
    post :create, :email => 'foobar', :permission => { :login => 'foobar' }
    assert_template 'new'
    assigns(:user).should.be.new_record
  end
end
