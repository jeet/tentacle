# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def author(profile_id)
    profile = Profile.find(profile_id) if profile_id
    (profile && profile.display_name) ? profile.display_name.to_s.capitalize : "Anonymous"
  end
  
  def gravatar_url(email, size=70)
    email ||= "nil@nil.com" 
    require 'digest/md5'
    digest = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar.php?size=#{size}&gravatar_id=#{digest}"
  end
  
end
