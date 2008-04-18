require File.dirname(__FILE__) + '/../spec_helper'

ModelStubbing.define_models :monitorships do
  model Monitorship do
    stub :profile => all_stubs(:profile), :topic => all_stubs(:topic), :active => true
    stub :inactive, :profile => all_stubs(:profile), :topic => all_stubs(:other_topic), :active => false
  end
end

describe Profile, "(monitorships)" do
  define_models :monitorships
  
  it "selects topics" do
    profiles(:default).monitored_topics.should == [topics(:default)]
  end
end

describe Topic, "(Monitorships)" do
  define_models :monitorships
  
  it "selects profiles" do
    topics(:default).monitoring_users.should == [profiles(:default)]
    topics(:other).monitoring_users.should == []
  end
end

describe Monitorship do
  define_models :monitorships

  it "adds user/topic relation" do
    topics(:other_forum).monitoring_users.should == []
    lambda do
      topics(:other_forum).monitoring_users << profiles(:default)
    end.should change { Monitorship.count }.by(1)
    topics(:other_forum).monitoring_users(true).should == [profiles(:default)]
  end

  it "adds profile/topic relation over inactive monitorship" do
    topics(:other).monitoring_users.should == []
    lambda do
      topics(:other).monitoring_users << profiles(:default)
    end.should raise_error(ActiveRecord::RecordNotSaved)
    topics(:other).monitoring_users(true).should == [profiles(:default)]
  end

  %w(profile_id topic_id).each do |attr|
    it "requires #{attr}" do
      mod = new_monitorship(:default)
      mod.send("#{attr}=", nil)
      mod.should_not be_valid
      mod.errors.on(attr).should_not be_nil
    end
  end
  
  it "doesn't add duplicate relation" do
    lambda do
      topics(:default).monitoring_users << profiles(:default)
    end.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  %w(topic profile).each do |model|
    it "is cleaned up after a #{model} is deleted" do
      send(model.pluralize, :default).destroy
      lambda do
        monitorships(:default).reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end