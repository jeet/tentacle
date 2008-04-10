class Friendship < ActiveRecord::Base
  belongs_to :requester, :class_name => 'Profile'
  belongs_to :requested, :class_name => 'Profile'
  
  def approve!
    self.approved = true
    save!
  end

  def unfriend!
    destroy
  end
end