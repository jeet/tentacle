require File.dirname(__FILE__) + '/../spec_helper'

def create_group(options = {})
  Group.new({:name => 'Funky Pants'}.merge(options))
end

describe Group do
  before(:each) do
    @group = create_group
  end

  it "should be valid" do
    @group.should be_valid
  end
  
  it "should require a group name" do
    profile = create_profile(:name => nil)
    profile.should_not be_valid
  end
  
  it "should have profile associated with it" do
  end
  
  it "should require a unique group name" do
  end
end