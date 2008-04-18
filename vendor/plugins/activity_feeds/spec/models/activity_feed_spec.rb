require File.dirname(__FILE__) + '/../spec_helper'

describe ActivityFeed do
  define_models :entries
  
  before(:each) do
    @activity_feed = ActivityFeed.for(users(:default).profile)
  end
  
  it "should find all my entries" do
    @activity_feed.for_me.length.should be == 3
  end
  
  it "should find all entries for a given person" do
    ActivityFeed.for(profiles(:default)).me.length.should be == 3
  end
  
  it "should find all my friends entries" do
    feed = @activity_feed.for_friends
    feed.length.should be == 2
  end
  
  it "should allow a user to locate her entries" do
    user = users(:default)
    user.profile.activity_feed.for_me
  end
  
  it "should allow a user to locate his friends' entries" do
    user = users(:default)
    user.profile.activity_feed.for_friends
  end
end
