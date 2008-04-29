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
end

def create_message(options = {})
  message = PrivateMessage.new({:recipient_id => 1, :sender_id => 2, :title => "oh hello", :body => "oh hey!"}.merge(options))
  message.recipient_id = 1
  message.sender_id = 2
  message.save
  message
end