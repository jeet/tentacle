class Profile < ActiveRecord::Base
  has_many :follower_friends, :class_name => "Friendship", :foreign_key => "requested_id", :conditions => 'approved = 0'
  has_many :following_friends, :class_name => "Friendship", :foreign_key => "requester_id", :conditions => 'approved = 0'
  has_many :approved_friendships, :class_name => "Friendship", :finder_sql => 'SELECT * FROM friendships WHERE ((requester_id = #{id}) OR (requested_id = #{id}) AND (approved = 1))', :uniq => true
  
  has_many :followers, :through => :follower_friends, :source => :requester
  has_many :followings, :through => :following_friends, :source => :requested
  has_many :friends, :class_name => "Profile", :finder_sql => 'SELECT * FROM profiles WHERE id IN (SELECT profiles.id FROM profiles, friendships WHERE (friendships.requested_id = #{id}) OR (friendships.requester_id = #{id}) AND profiles.id <> #{id});'
  
  def request_friendship_with(user)
    Friendship.create(:requested_id => user.id, :requester_id => id, :approved => false)
  end
end