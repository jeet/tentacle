class Profile < ActiveRecord::Base
  belongs_to :user
  
  has_many :friendships, :class_name  => "Friendship", :conditions => '(requester_id=#{id} OR requested_id=#{id}) AND status = #{Friendship::APPROVED}'
  has_many :follower_friends, :class_name => "Friendship", :foreign_key => "requested_id", :conditions => "status = #{Friendship::PENDING}"
  has_many :following_friends, :class_name => "Friendship", :foreign_key => "requester_id", :conditions => "status = #{Friendship::PENDING}"
  
  has_many :friends,   :through => :friendships, :source => :requested
  has_many :followers, :through => :follower_friends, :source => :requester
  has_many :followings, :through => :following_friends, :source => :requested
   
  validates_format_of     :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i, :allow_nil => true
  validates_uniqueness_of :email, :if => lambda { |p| !p.email.blank? }
  
  before_save   :sanitize_email
  
  def sanitized_email
    if !email.blank? && email =~ /^([^@]+)@(.*?)(\.co)?\.\w+$/
      "#{$1} (at #{$2})"
    end
  end

  def email=(value)
    write_attribute :email, value.blank? ? value : value.downcase
  end
  
  protected
    def sanitize_email
      encrypt_password! unless password.blank?
      email.downcase!   unless email.blank?
    end
    
end
