require File.dirname(__FILE__) + '/../spec_helper'

describe PrivateMessagesController do
  define_models
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
    end.should change(profiles(:rick), :private_messages_count)
  end
  
  it "should let me see my messages" do
    get :index
    response.should be_success
    
    assigns[:private_messages].should == profiles(:rick).private_messages.paginate
  end
  
  # it "should not let me see a message to another user" do
  # end
  # 
  # it "should let me see a message sent to me" do
  # end
  
  it "should not let me delete another user's message" do
    lambda do
      delete :destroy, :id => private_messages(:other_people).id
    end.should_not change(profiles(:virginia), :private_messages_count)
  end
  
  it "should let me delete (hide) messages sent to me" do
    lambda do
      lambda do
        delete :destroy, :id => private_messages(:default).id
      end.should change(profiles(:rick), :private_messages_count)
    end.should_not change(profiles(:virginia), :private_messages_count)      
  end
  
  it "should let me delete (hide) messages sent by me" do
    lambda do
      lambda do
        delete :destroy, :id => private_messages(:other).id
      end.should change(profiles(:rick), :private_messages_count)
    end.should_not change(profiles(:virginia), :private_messages_count)
  end
  
  it "should delete a message if both sender and recipient delete (hide) it" do 
    lambda do
      delete :destroy, :id => private_messages(:sender_deleted).id
    end.should change(PrivateMessage, :count)
  end
end
