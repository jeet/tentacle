class Profile < ActiveRecord::Base
  has_many :follower_friends, :class_name => "Friendship", :foreign_key => "requested_id", :conditions => 'approved = 0'
  has_many :following_friends, :class_name => "Friendship", :foreign_key => "requester_id", :conditions => 'approved = 0'
  has_many :approved_friendships, :class_name => "Friendship", :finder_sql => 'SELECT * FROM friendships WHERE ((requester_id = #{id}) OR (requested_id = #{id}) AND (approved = 1));', :uniq => true, :dependent => :destroy
  
  has_many :followers, :through => :follower_friends, :source => :requester
  has_many :followings, :through => :following_friends, :source => :requested
  has_many :friends, :class_name => "Profile", :finder_sql => 'SELECT * FROM profiles WHERE id IN (SELECT requester_id FROM friendships WHERE requested_id = #{id} AND approved = 1 UNION SELECT requested_id FROM friendships WHERE requester_id = #{id} AND approved = 1);', :counter_sql => 'SELECT COUNT(*) FROM profiles WHERE id IN (SELECT requester_id FROM friendships WHERE requested_id = #{id} AND approved = 1 UNION SELECT requested_id FROM friendships WHERE requester_id = #{id} AND approved = 1);'
  def request_friendship_with(user)
    Friendship.create(:requested_id => user.id, :requester_id => id, :approved => false)
  end
end