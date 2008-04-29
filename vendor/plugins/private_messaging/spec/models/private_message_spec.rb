require File.dirname(__FILE__) + '/../spec_helper'

describe PrivateMessage do
  define_models
  
  before(:each) do
    @message = create_message
  end

  it "should be valid" do
    @message.should be_valid
  end
  
  it "should require a sender and recipient" do
    [:recipient_id, :sender_id].each do |attr|
      message = create_message
      message.send("#{attr}=", nil)
      message.should_not be_valid
    end
  end
  
  it "should require a body and a title" do
    [:body, :title].each do |attr|
      message = create_message(attr => nil)
      message.should_not be_valid
    end
  end
  
  it "should tell me if a profile is the recipient" do
    message = private_messages(:default)
    message.recipient?(profiles(:rick)).should be_true
  end
  
  it "should tell me if a profile is not the recipient" do
    message = private_messages(:other)
    message.recipient?(profiles(:rick)).should be_false
  end
  
  it "should tell me if a profile is the sender" do
    message = private_messages(:other)
    message.sender?(profiles(:rick)).should be_true
  end
  
  it "should tell me if a profile is not the sender" do
    message = private_messages(:default)
    message.sender?(profiles(:rick)).should be_false
  end
  
  it "should tell me if a profile can edit this message" do
    message = private_messages(:other)
    message.editable_by?(profiles(:rick)).should be_true
  end
  
  it "should tell me if a profile can not edit a message" do
    message = private_messages(:default)
    message.editable_by?(profiles(:rick)).should be_false
  end
  
  it "should tell me if a profile can see a message" do
    message = private_messages(:default)
    message.viewable_by?(profiles(:rick)).should be_true
  end
  
  it "should tell me if a profile can not see a message" do
    message = private_messages(:other_people)
    message.viewable_by?(profiles(:rick)).should be_false
    
    message = private_messages(:default)
    message.recipient_deleted = true
    message.viewable_by?(profiles(:rick)).should be_false
    
    message = private_messages(:other)
    message.sender_deleted = true
    message.viewable_by?(profiles(:rick)).should be_false
  end
  
  it "should delete a message on the sender side" do
    message = private_messages(:other)
    message.delete_by!(profiles(:rick))
    
    message.sender_deleted.should be_true
    message.viewable_by?(profiles(:rick)).should be_false
  end
  
  it "should delete a message on the recipient side" do
    message = private_messages(:default)
    message.delete_by!(profiles(:rick))
    
    message.recipient_deleted.should be_true
    message.viewable_by?(profiles(:rick)).should be_false
  end
  
  it "should destroy a message if both sender and receiver delete it" do
    lambda do
      message = private_messages(:sender_deleted)
      message.delete_by!(profiles(:rick))      
    end.should change(PrivateMessage, :count)

    lambda do
      message = private_messages(:recipient_deleted)
      message.delete_by!(profiles(:virginia))
    end.should change(PrivateMessage, :count)    
  end
  
  it "should find messages associated with a profile (e.g., either sender or recipient)" do
    PrivateMessage.find_associated_with(profiles(:rick)).length.should == 3
  end
  
  it "should count messages associated with a profile" do
    PrivateMessage.count_associated_with(profiles(:rick)).should == 3
  end
  
  it "should find messages between two profiles" do
    PrivateMessage.find_between(profiles(:rick), profiles(:virginia)).length.should == 3
  end
  
  it "should count messages between two profiles" do
    PrivateMessage.count_between(profiles(:rick), profiles(:virginia)).should == 3
  end
  
  it "should format its body with Textile" do
    message = private_messages(:default)
    message.body = "a *few* of my *favorite* things"
    message.save!
    
    message.body_html.should == "<p>a <strong>few</strong> of my <strong>favorite</strong> things</p>"
  end
end

def create_message(options = {})
  message = PrivateMessage.new({:recipient_id => 1, :sender_id => 2, :title => "oh hello", :body => "oh hey!"}.merge(options))
  message.recipient_id = 1
  message.sender_id = 2
  message.save
  message
end