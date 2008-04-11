require File.dirname(__FILE__) + '/../spec_helper'

describe GroupsController do
  it "should, in fact, be GroupsController" do
    controller.should be_an_instance_of(GroupsController)
  end
end

describe GroupsController, "with a non-logged in user" do
  fixtures :users, :profiles
  integrate_views
  
  before do
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return users(:rick)
  end
  
  it "should not create a group" do
  end
  
  it "should not edit a group" do
  end
  
  it "should not destroy a group" do
  end
  
  it "should show a group" do
  end
end

describe GroupsController, "with a logged in user" do
  fixtures :users, :profiles
  integrate_views
  
  before do
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return users(:rick)
  end
  
  it "should not create a group" do
  end
  
  it "should not edit a group" do
  end
  
  it "should not destroy a group" do
  end
  
  it "should show a group" do
  end
end

describe GroupsController, "with an administrator" do
  fixtures :users, :profiles
  integrate_views
  
  before do
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return users(:rick)
  end
  
  it "should, in fact, be GroupsController" do
    controller.should be_an_instance_of(GroupsController)
  end
  
  it "should not create a group" do
  end
  
  it "should not edit a group" do
  end
  
  it "should not destroy a group" do
  end
  
  it "should show a group" do
  end
end