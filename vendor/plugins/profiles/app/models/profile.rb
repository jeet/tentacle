# == Schema Information
# Schema version: 9
#
# Table name: profiles
#
#  id         :integer(11)     not null, primary key
#  user_id    :integer(11)     
#  first_name :string(255)     
#  last_name  :string(255)     
#  website    :string(255)     
#  about      :string(255)     
#  created_at :datetime        
#  updated_at :datetime        
#  email      :string(255)     
#

class Profile < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :first_name, :last_name, :email
  
  validates_format_of     :email, :with => /(\A(\s*)\Z)|(\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z)/i, :allow_nil => true
  validates_uniqueness_of :email, :if => lambda { |p| !p.email.blank? }
  
  before_save   :sanitize_email
  
  def sanitized_email
    if !email.blank? && email =~ /^([^@]+)@(.*?)(\.co)?\.\w+$/
      "#{$1} (at #{$2})"
    end
  end

  def email=(value)
    write_attribute :email, value.blank? ? value : value.downcase
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end

  protected
    def sanitize_email
      email.downcase!   unless email.blank?
    end
    
end
