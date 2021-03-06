module UsersHelper

  def user_count
    pluralize current_group.users.size, 'user'[:user]
  end
  
  def active_user_count
    pluralize current_group.users.count('users.posts_count > 0'), 'active user'[:active_user]
  end
  
  def lurking_user_count
    pluralize current_group.users.count('users.posts_count = 0'), 'lurking user'[:lurking_user]
  end

end