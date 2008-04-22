class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, :class_name => "Profile", :foreign_key => "profile_id"

  validates_uniqueness_of :group_id, :scope => :profile_id
  
  before_create :set_first_user_admin
  def set_first_user_admin
    self.transaction do
      if group && group.members.count == 0
        self.admin = true
      end
    end
  end
  
  def self.join_from(group_id, profile_id)
    find :first, :conditions => { :group_id => group_id, :profile_id => profile_id }
  end
  
end