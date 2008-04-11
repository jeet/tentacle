require File.dirname(__FILE__) + '/../spec_helper'

describe Membership do

  def create_membership(options = {})
    Membership.new({:group_id => 1, :profile_id => 1}.merge(options))
  end

  before(:each) do
    @membership = create_membership
  end

  it "should be valid" do
    @membership.should be_valid
  end
  
  #it "should allow a user to join a group" do
  #  profile = create_profile(:name => nil)
  #  profile.should_not be_valid
  #end
  
  it "should allow a user to leave a group" do
    pending 
  end
end