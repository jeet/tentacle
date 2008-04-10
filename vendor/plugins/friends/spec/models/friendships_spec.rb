require File.dirname(__FILE__) + '/../spec_helper'

def create_friendship(options = {})
  Friendship.new({:requested_id => 1, :requester_id => 2, :approved => 0}.merge(options))
end

describe Friendship do
  fixtures :friendships, :users, :profiles
  
  before(:each) do
    @user = User.find(1)
    @user2 = User.find(2)
    @friendship = create_friendship
  end

  it "should be valid" do
    @friendship.should be_valid
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
    virginia = users(:virginia)
    
    lambda do
      virginia.profile.follower_friends.first.approve!
      virginia.profile.reload
    end.should change(virginia.profile.friends, :count).by(1)
  end
  
  it "should keep track of followers" do
  end
end
