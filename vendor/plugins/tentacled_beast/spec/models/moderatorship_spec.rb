require File.dirname(__FILE__) + '/../spec_helper'

describe Moderatorship do
  define_models do
    model Moderatorship do
      stub :profile => all_stubs(:profile), :forum => all_stubs(:forum)
    end
    
    model Group do
      stub :other, :name => 'other'
    end
    
    model Forum do
      stub :other_site, :name => "Other", :group => all_stubs(:group)
    end
  end

  it "adds user/forum relation" do
    forums(:other).moderators.should == []
    lambda do
      forums(:other).moderators << profiles(:default)
    end.should change { Moderatorship.count }.by(1)
    forums(:other).moderators(true).should == [profiles(:default)]
  end
  
  %w(profile_id forum_id).each do |attr|
    it "requires #{attr}" do
      mod = new_moderatorship(:default)
      mod.send("#{attr}=", nil)
      mod.should_not be_valid
      mod.errors.on(attr).should_not be_nil
    end
  end
  
  it "doesn't add duplicate relation" do
    lambda do
      forums(:default).moderators << profiles(:default)
    end.should raise_error(ActiveRecord::RecordInvalid)
  end
  
  %w(forum profile).each do |model|
    it "is cleaned up after a #{model} is deleted" do
      send(model.pluralize, :default).destroy
      lambda do
        moderatorships(:default).reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

ModelStubbing.define_models :moderators do
  model Profile do
    stub :other, :email => '@example.com'
  end

  model Moderatorship do
    stub :profile => all_stubs(:profile), :forum => all_stubs(:forum)
    stub :default_other, :profile => all_stubs(:profile), :forum => all_stubs(:other_forum)
    stub :other_default, :profile => all_stubs(:other_profile)
  end
end

describe Forum, "#moderators" do
  define_models :moderators

  it "finds moderators for forum" do
    forums(:default).moderators.sort_by {|prof| prof.user.login}.should == [profiles(:default), profiles(:other)]
    forums(:other).moderators.should == [profiles(:default)]
  end
end

describe Profile, "#forums" do
  define_models :moderators

  it "finds forums for profiles" do
    profiles(:default).forums.sort_by(&:name).should == [forums(:default), forums(:other)]
    profiles(:other).forums.should == [forums(:default)]
  end
end