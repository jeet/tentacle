class User
  after_create :set_first_user_as_activated
  def set_first_user_as_activated
    activate! if group.nil? or group.users.size <= 1
  end
  
  def token_expires_at?
    active? && token_expires_at_expires_at && Time.now.utc < token_expires_at_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now
  end

  def remember_me_until(time)
    self.token_expires_at_expires_at = time.utc
    self.token_expires_at            = encrypt("#{email}--#{token_expires_at_expires_at}")
    save(false)
  end

  def forget_me
    self.token_expires_at_expires_at = nil
    self.token_expires_at            = nil
    save(false)
  end
end