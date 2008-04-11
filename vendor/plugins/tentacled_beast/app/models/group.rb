class Group < ActiveRecord::Base
  has_many :users, :conditions => {:state => 'active'}
  has_many :all_users, :class_name => 'User'
  
  has_many :forums
  has_many :topics, :through => :forums
  has_many :posts,  :through => :forums
  
  attr_readonly :posts_count, :users_count, :topics_count
  
  def ordered_forums(*args)
    forums.ordered(*args)
  end
end