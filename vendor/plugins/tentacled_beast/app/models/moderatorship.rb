class Moderatorship < ActiveRecord::Base
  belongs_to :profile
  belongs_to :forum
  validates_presence_of :profile_id, :forum_id
  validate :uniqueness_of_relationship
  
protected
  def uniqueness_of_relationship
    if self.class.exists?(:profile_id => profile_id, :forum_id => forum_id)
      errors.add_to_base("Cannot add duplicate profile/forum relation")
    end
  end
end
