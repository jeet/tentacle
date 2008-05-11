class Profile < ActiveRecord::Base
  has_many :private_messages_sent, :foreign_key => 'sender_id', :class_name => 'PrivateMessage', :order => PrivateMessage.default_order
  has_many :private_messages_received, :foreign_key => 'recipient_id', :class_name => 'PrivateMessage', :order => PrivateMessage.default_order

  def private_messages(options = {})
    PrivateMessage.find_associated_with(self, options)
  end
  
  def private_messages_count
    PrivateMessage.count_associated_with(self)
  end
  
  def private_messages_with_profile(profile, options = {})
    PrivateMessage.find_between(self, profile, options)
  end

  def private_messages_with_profile_count(profile)
    PrivateMessage.count_between(self, profile)
  end  
end
