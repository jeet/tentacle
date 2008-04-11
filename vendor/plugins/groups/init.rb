# Include hook code here

Dependencies.load_once_paths.delete lib_path
Rails.plugin_routes << :groups

Profile.has_many :memberships