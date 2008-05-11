require File.dirname(__FILE__) + '/../spec_helper'
require 'pp'

describe "A user that can friend" do
  fixtures :users, :profiles
  
  before(:each) do
    @rick = users(:rick)
    @virginia = users(:virginia)
  end
  
  it "should create followings when a user requests a friendship" do
    lambda do
      @rick.profile.request_friendship_with @virginia.profile
      @rick.profile.reload      
    end.should change(@rick.profile.followings, :count).by(1)
  end
  
  it "should create friendships when a user approves a request" do
    @rick = users(:rick)
    @virginia = users(:virginia)

    lambda do
      @rick.profile.request_friendship_with @virginia.profile
      @virginia.profile.follower_friends.first.approve!
      @virginia.profile.reload
    end.should change(@virginia.profile.friends, :count).by(1)
  end
  
  it "should keep track of followers" do
    lambda do
      @rick.profile.request_friendship_with @virginia.profile
      @virginia.profile.reload
    end.should change(@virginia.profile.followers, :count).by(1)
  end
  
  it "should allow unfriending" do
    lambda do
      @rick.profile.request_friendship_with @virginia.profile
      # Friends + 1
      @virginia.profile.follower_friends.first.approve!
      @virginia.profile.reload
      
      # Friends - 1
      @virginia.profile.approved_friendships.first.unfriend!
      @virginia.profile.reload
    end.should_not change(@virginia.profile.friends, :count)
  end  
end
