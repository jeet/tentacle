require File.dirname(__FILE__) + '/../spec_helper'

describe PrivateMessagesController do
  fixtures :users, :profiles, :private_messages
  integrate_views
  
  before do
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return users(:rick)
  end
  
  it "should, in fact, be PrivateMessagesController" do
    controller.should be_an_instance_of(PrivateMessagesController)
  end
  
  it "should let me send a message" do
    lambda do
      post :create, :private_message => { :recipient_id => users(:virginia).profile.id, :title => "hello", :body => "don't cry, virginia" }

      response.should be_redirect
    end.should change(PrivateMessage, :count)
    
    users(:rick).profile.private_messages_with_profile_count(users(:virginia).profile).should == 1
  end
  
  it "should let me see my messages" do
    require 'pp'
    pp users(:rick).profile.private_messages
    get :index
    
    assigns[:private_messages].should == users(:rick).private_messages
  end
  
  it "should not let me see a message to another user" do
  end
  
  it "should let me see a message sent to me" do
  end
  
  it "should not let me delete another user's message" do
  end
  
  it "should let me delete messages sent to me" do
  end
  
  it "should not let me delete messages sent by me" do
  end
end
