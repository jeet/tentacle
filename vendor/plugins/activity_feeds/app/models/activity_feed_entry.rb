class ActivityFeedEntry < ActiveRecord::Base
  belongs_to :profile
  
  validates_presence_of :profile_id
  
  validates_presence_of :entry
end