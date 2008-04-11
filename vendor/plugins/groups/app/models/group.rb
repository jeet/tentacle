class Group < ActiveRecord::Base
  has_many :memberships
  has_many :members, :class_name => 'Profile', :through => :memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # todo: SEO url style group name slugs
  def to_param
    name
  end
end