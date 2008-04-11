class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, :class_name => "Profile", :foreign_key => "profile_id"

end