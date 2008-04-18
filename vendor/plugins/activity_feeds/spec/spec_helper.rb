# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = 'spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

ModelStubbing.define_models do
  model User do
    stub :login => 'normal-user', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1'
    stub :other, :login => 'other-user', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1'
  end

  model Profile do
    stub :user => all_stubs(:user), :first_name => "Addy", :last_name => "McAdmin", :website => "This one", :about => "o hai.", :email => "emailzz@zz.com", :permalink => "un-deet"
    stub :other, :user => all_stubs(:other_user), :first_name => "Pansy", :last_name => "O'Pantsy", :website => "That one", :about => "o bai.", :email => "ONOEZ@zz.com", :permalink => "tee-pee"
  end
end

ModelStubbing.define_models :entries do
  model Friendship do
    stub :requester => all_stubs(:profile), :requested => all_stubs(:other_profile), :approved => true
  end
  
  model ActivityFeedEntry do
    stub :profile => all_stubs(:profile), :entry => "just ate a sandwich."
    stub :jesus, :profile => all_stubs(:profile), :entry => "befriended Jesus."
    stub :foozeball, :profile => all_stubs(:profile), :entry => "likes to play foozeball."
    stub :snapped, :profile => all_stubs(:other_profile), :entry => "snapped her fingers."
    stub :sneeze, :profile => all_stubs(:other_profile), :entry => "just sneezed."
  end
end