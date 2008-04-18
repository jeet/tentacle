class ActivityFeed
  def self.for(profile)
    ActivityFeed.new(profile)
  end
  
  def initialize(profile)
    @profile = profile
  end
  
  def for_me
    @profile.activity_feed_entries
  end
  
  alias :me :for_me
  
  def for_friends
    ids = @profile.friends.map(&:id)
    ActivityFeedEntry.find(:all, :conditions => ['profile_id IN (?)', ids.join(',')])
  end
  
  alias :friends :for_friends
end