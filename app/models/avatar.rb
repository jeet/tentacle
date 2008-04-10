# == Schema Information
# Schema version: 9
#
# Table name: avatars
#
#  id           :integer(11)     not null, primary key
#  content_type :string(255)     
#  filename     :string(255)     
#  size         :integer(11)     
#  parent_id    :integer(11)     
#  thumbnail    :string(255)     
#  width        :integer(11)     
#  height       :integer(11)     
#

class Avatar < ActiveRecord::Base
  has_attachment :storage => :file_system, :content_type => :image, :resize_to => '32x32'
  validates_as_attachment
  validates_length_of :filename, :maximum => 255
  before_destroy { |r| User.update_all 'avatar_id = NULL', ['avatar_id = ?', r.id] unless r.new_record? }
end
