require File.dirname(__FILE__) + '/../spec_helper'

def create_profile(options = {})
  Profile.new({:first_name => 'Boom', :last_name => 'Shakkalaka', :website => 'http://life.com', :about => 'Fawesome developer.  Handsome dude.  Priceless.', :email => "o.hai.#{Time.now.to_i}@gmail.com", :user_id => 4}.merge(options))
end

describe Profile do
  before(:each) do
    @profile = create_profile
  end

  it "should be valid" do
    @profile.should be_valid
  end
  
  it "should require first name, last name, and e-mail" do
    [:first_name, :last_name, :email].each do |attr|
      profile = create_profile(attr => nil)
      profile.should_not be_valid
    end
  end
  
  it "should require a properly formatted e-mail" do
    @profile.should be_valid
    
    profile = create_profile(:email => 'ohai')
    profile.should_not be_valid
  end
  
  it "should provide a sanitized e-mail" do
    profile = create_profile(:email => 'THINGSgoWELL@oHAI.com')
    profile.sanitized_email.should == 'thingsgowell (at ohai)'
  end
  
  it "should provide the user's full name" do
    @profile.full_name.should == 'Boom Shakkalaka'
  end
  
  it "shouldn't allow for duplicate e-mail addresses" do
    create_profile(:email => 'feep@meep.com').save
    profile = create_profile(:email => 'feep@meep.com')
    profile.should_not be_valid
  end
end
