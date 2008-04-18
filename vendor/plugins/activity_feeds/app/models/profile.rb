# Haxxie to the maxxie?
class Profile < ActiveRecord::Base
  has_many :activity_feed_entries
  
  def activity_feed
    ActivityFeed.for(self)
  end
end
