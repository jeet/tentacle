module Profile::Editable
  def editable_by?(profile)
    profile && (profile.id == profile_id || profile.moderator_of?(forum))
  end
end