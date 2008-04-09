class Friendship < ActiveRecord::Base
  belongs_to :requester, :class_name => 'Profile'
  belongs_to :requested, :class_name => 'Profile'
  
  
end
