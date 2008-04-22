require_dependency 'profile'
require 'forwardable'

class Profile
  extend Forwardable
  
  #concerned_with :validation, :states, :activation, :posting
  concerned_with :posting
  
  has_many :posts, :order => "#{Post.table_name}.created_at desc"
  has_many :topics, :order => "#{Topic.table_name}.created_at desc"
  
  has_many :moderatorships, :dependent => :delete_all
  has_many :forums, :through => :moderatorships, :source => :forum
  
  has_many :monitorships, :dependent => :delete_all
  has_many :monitored_topics, :through => :monitorships, :source => :topic, :conditions => {"#{Monitorship.table_name}.active" => true}
  
  def_delegator :user, :admin, :admin  
  def_delegator :user, :admin?, :admin?  
  def_delegator :user, :admin=, :admin=
  
  # has_permalink :login
  
  attr_readonly :last_seen_at #, posts_count

  def self.prefetch_from(records)
    find(:all, :select => 'distinct *', :conditions => ['id in (?)', records.collect(&:profile_id).uniq])
  end
  
  def self.index_from(records)
    prefetch_from(records).index_by(&:id)
  end

  def available_forums
    @available_forums ||= group.ordered_forums - forums
  end

  def moderator_of?(forum)
    return true if admin?
    member = Membership.join_from(forum.group, self) 
    return true if member && member.admin?
    return true if Moderatorship.exists?(:profile_id => id, :forum_id => forum.id)
  end

  def display_name
    full_name
  end
  #  n = read_attribute(:login)
  #end
  
  # this is used to keep track of the last time a profile has been seen (reading a topic)
  # it is used to know when topics are new or old and which should have the green
  # activity light next to them
  #
  # we cheat by not calling it all the time, but rather only when a profile views a topic
  # which means it isn't truly "last seen at" but it does serve it's intended purpose
  #
  # This is now also used to show which profiles are online... not at accurate as the
  # session based approach, but less code and less overhead.
  def seen!
    now = Time.now.utc
    self.class.update_all ['last_seen_at = ?', now], ['id = ?', id]
    write_attribute :last_seen_at, now
  end
  
  def to_param
    user.login # id # permalink
  end
end
