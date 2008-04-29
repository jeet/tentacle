class PrivateMessage < ActiveRecord::Base
  def self.per_page() 25 end

  belongs_to :sender, :class_name => 'Profile', :foreign_key => 'sender_id'
  belongs_to :recipient, :class_name => 'Profile', :foreign_key => 'recipient_id'

  format_attribute :body

  validates_presence_of :sender_id, :recipient_id, :body, :title
  attr_accessible :title, :body
  
  def editable_by?(profile)
    profile && (profile.id == sender_id)
  end
  
  def viewable_by?(profile)
    raise (sender?(profile) && !self.sender_deleted?).inspect
    (recipient?(profile) && !self.recipient_deleted?))
  end

  def delete_by!(profile)
    self.sender_deleted = true if sender?(profile)
    self.recipient_deleted = true if recipient?(profile)

    if sender_deleted? && recipient_deleted?
      destroy
    else
      save!
    end
  end
  
  def sender?(profile)
    sender_id == profile.id
  end
  
  def recipient?(profile)
    recipient_id == profile.id
  end

  def self.find_associated_with(profile, opts = {})
    find_options = associated_with_condition(profile).merge!(:order => default_order)
    find_options.merge!(opts)
    find(:all, find_options)
  end

  def self.count_associated_with(profile)
    count(associated_with_condition(profile))
  end

  def self.find_between(profile, other_profile, opts = {})
    find_options = between_condition(profile, other_profile).merge!(:order => default_order)
    find_options.merge!(opts)
    find(:all, find_options)
  end

  def self.count_between(profile, other_profile)
    count(between_condition(profile, other_profile))
  end

  def self.default_order
    "#{table_name}.created_at DESC"
  end
  
  protected
  
    def self.between_condition(profile, other_profile)
      {:conditions => [ '(sender_id = ? AND recipient_id = ? AND sender_deleted = ?) OR (sender_id = ? AND recipient_id = ? AND recipient_deleted = ?)',
          profile.id, other_profile.id, false, other_profile.id, profile.id, false ]}
    end

    def self.associated_with_condition(profile)
      {:conditions => [ '(sender_id = ? AND sender_deleted = ?) OR (recipient_id = ? AND recipient_deleted = ?)',
          profile.id, false, profile.id, false]}
    end
  
end
