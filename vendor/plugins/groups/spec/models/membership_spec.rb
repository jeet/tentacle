require File.dirname(__FILE__) + '/../spec_helper'

def create_group(options = {})
  Membership.new({:group_id => 1, :profile_id => 1}.merge(options))
end

describe Membership do
  before(:each) do
    @group = create_group
  end

  it "should be valid" do
    @group.should be_valid
  end
  
  it "should allow a user to join a group" do
    profile = create_profile(:name => nil)
    profile.should_not be_valid
  end
  
  it "should allow a user to leave a group" do
  end
end