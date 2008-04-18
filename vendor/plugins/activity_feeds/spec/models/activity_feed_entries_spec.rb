require File.dirname(__FILE__) + '/../spec_helper'

def create_entry(options = {})
  ActivityFeedEntry.create({:profile_id => 1, :entry => "has just added a new friend."}.merge(options))
end

describe ActivityFeedEntry do
  define_models
  
  before(:each) do
    @entry = create_entry
  end

  it "should be valid" do
    @entry.should be_valid
  end
  
  it "should require a profile_id" do
    entry = create_entry(:profile_id => nil)
    entry.should_not be_valid
  end
  
  it "should require entry text " do
    entry = create_entry(:entry => nil)
    entry.should_not be_valid
  end
  
  it "should create an entry for a user" do
    user = users(:default)
    
    lambda do
      user.profile.activity_feed_entries.create(:entry => 'just pooped his pants.')
      user.reload
    end.should change(user.profile.activity_feed_entries, :count)
  end
end
