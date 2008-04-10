require File.dirname(__FILE__) + '/../spec_helper'

describe ProfilesController do
  fixtures :users, :profiles
  integrate_views
  
  before do
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return users(:rick)
  end
  
  it "should, in fact, be ProfilesController" do
    controller.should be_an_instance_of(ProfilesController)
  end
  
  it "should give me my profile when I ask for `me`" do
    get :show, :id => 'me'
    response.should be_success
    assigns[:profile].should be == users(:rick).profile
  end
  
  it "should render `edit` with my profile" do
    get :edit, :id => 'me'
    response.should be_success
    assigns[:profile].should be == users(:rick).profile
  end
  
  it "should redirect if you try to edit someone else's profile" do
    get :edit, :id => 'my_humps'
    response.should redirect_to('profiles/me/edit')
    assigns[:profile].should be == nil
  end
  
  it "should render a profile with a username" do
    get :show, :id => 'virginia'
    response.should be_success
    assigns[:profile].should be == users(:virginia).profile
  end
  
  it "should let me update my profile" do
    lambda do
      post :update, :id => 'me', :profile => { :about => "meeee hehehe" }
    end.should change(users(:rick).profile, :about)
  end
  
  it "should let me update my profile, even if you want to update someone else's" do
    lambda do
      post :update, :id => 'someone_else', :profile => { :about => "meeee hehehe" }
    end.should change(users(:rick).profile, :about)
  end
end
