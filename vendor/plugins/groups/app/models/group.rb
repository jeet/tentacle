unless defined?(Group)
  $stderr.puts "Defining group 2"
  class Group < ActiveRecord::Base
  end
end

class Group
  has_many :memberships
  has_many :members, :class_name => 'Profile', :through => :memberships
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  # todo: SEO url style group name slugs
  def to_param
    name
  end
  
end