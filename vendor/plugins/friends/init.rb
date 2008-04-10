require 'friends'

# Include hook code here
ActiveRecord::Base.send(:extend, Friends::ClassMethods)