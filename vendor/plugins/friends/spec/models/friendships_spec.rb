require File.dirname(__FILE__) + '/../spec_helper'

describe "A user that can friend" do
  fixtures :users, :profiles, :friendships
  
  before(:each) do
    @user = User.find(1)
    @user2 = User.find(2)
  end
  
  it "should create followings when a user requests a friendship" do
    rick = users(:rick)
    virginia = users(:virginia)

    lambda do
      rick.profile.request_friendship_with virginia.profile
      rick.profile.reload
    end.should change(rick.profile.followings, :count).by(1)
  end
  
  it "should create friendships when a user approves a request" do
    rick = users(:rick)
    virginia = users(:virginia)

    lambda do
      rick.profile.request_friendship_with virginia.profile
      virginia.profile.follower_friends.first.approve!
      virginia.profile.reload
    end.should change(virginia.profile.friends, :count).by(1)
  end
  
  it "should keep track of followers" do
    rick = users(:rick)
    virginia = users(:virginia)

    lambda do
      rick.profile.request_friendship_with virginia.profile
      virginia.profile.reload
    end.should change(virginia.profile.followers, :count).by(1)
  end
  
  it "should allow unfriending" do
    rick = users(:rick)
    virginia = users(:virginia)

    lambda do
      rick.profile.request_friendship_with virginia.profile
      virginia.profile.follower_friends.first.approve!
      virginia.profile.reload
      
      virginia.profile.approved_friendships.first.unfriend!
      virginia.profile.reload
    end.should_not change(virginia.profile.friends, :count)
  end
end
