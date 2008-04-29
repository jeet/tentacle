require File.dirname(__FILE__) + '/../spec_helper'

describe PrivateMessage do
  fixtures :users, :profiles, :private_messages
  
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
  end
  
  it "should tell me if a profile is the sender" do
  end
  
  it "should tell me if a profile can edit this message" do
  end
  
  it "should tell me if a profile can see a message" do
  end
  
  it "should delete a message on the sender side" do
  end
  
  it "should delete a message on the recipient side" do
  end
  
  it "should destroy a message if both sender and receiver delete it" do
  end
  
  it "should find messages associated with a profile (e.g., either sender or recipient)" do
  end
  
  it "should count messages associated with a profile" do
  end
  
  it "should find messages between two profiles" do
  end
  
  it "should count messages between two profiles" do
  end
  
  it "should format its body with Textile" do
  end
end

def create_message(options = {})
  message = PrivateMessage.new({:recipient_id => 1, :sender_id => 2, :title => "oh hello", :body => "oh hey!"}.merge(options))
  message.recipient_id = 1
  message.sender_id = 2
  message.save
  message
end