require File.dirname(__FILE__) + '/../spec_helper'

module NamedExtension
  def one
    1
  end
end

class Being < ActiveRecord::Base
  has_finder :all
  has_finder :greeks, :conditions => {:country => 'greece'}
  has_finder :mortals, :conditions => {:race => 'mortal'}
  has_finder :located_in, lambda {|country| { :conditions => {:country => country } } }
  has_finder :anonymous_extension do
    def one
      1
    end
  end
  has_finder :named_extension, :extend => NamedExtension
  has_finder :both_named_and_anonymous_extension, :extend => NamedExtension do
    def two
      2
    end
  end
end

class BeingSubclass < Being
end

class Property < ActiveRecord::Base
  has_finder :starts_with, lambda {|l| { :conditions => "name LIKE '#{l}%'" } }
end

describe Being, 'active record behavior' do
  it "should reload when told" do
    original_being_size = Being.all.size
    Being.create
    Being.all.reload.size.should == original_being_size + 1
  end
end

describe Being, 'method missing' do
  it "should pass active record messages back to the base class" do
    Being.all.find(:all).should == Being.find(:all)
    Being.all.find(:first).should == Being.find(:first)
    Being.all.count.should == Being.count
    Being.all.average(:id).should == Being.average(:id)
  end
  
  it "should pass everything else (equality, enumerability, etc.) to a local result set" do
    Being.all.should == Being.find(:all)
    Being.all.collect.should == Being.find(:all)
    Being.all.each {|i| i}.should == Being.find(:all)
  end
end

describe BeingSubclass do
  it "should inherit has_finders from superclass" do
    BeingSubclass.all.find(:all).should == BeingSubclass.find(:all)
  end
end

describe Being, 'has_finder with options' do
  it "should scope basic finding to active record messages to the supplied options" do
    Being.greeks.should == [beings(:socrates), beings(:zeus)]
    Being.mortals.should == [beings(:socrates), beings(:xerxes)]
  end

  it "should scope all active record messages" do
    Being.greeks.find(:first).should == beings(:socrates)
  end
  
  it "should allow composition of finders" do
    Being.greeks.mortals.should == [beings(:socrates)]
  end
end

describe Being, 'has_finder with procedural options' do
  it "bleh" do
    Being.located_in('greece').count.should == 2
    Being.located_in('greece').sum(:id).should == Being.located_in('greece').map(&:id).sum
  end
  
  it "should use evaluated procedure as the scope options" do
    Being.located_in('greece').should == [beings(:socrates), beings(:zeus)]    
    Being.located_in('greece').find(:first).should == beings(:socrates)
  end
end

describe Being, 'supports extensions' do
  it "should support inline (anonymous) extensions" do
    Being.anonymous_extension.one.should == 1
  end
  
  it "should support named extensions" do
    Being.named_extension.one.should == 1
  end
  
  it "should support named extensions and anonymous extensions simultaneously" do
    Being.both_named_and_anonymous_extension.one.should == 1
    Being.both_named_and_anonymous_extension.two.should == 2
  end
  
end

describe Being, 'has many associations work with finders' do
  it "should scope finder to association proxy scope" do
    Property.starts_with('r').should == [properties(:red), properties(:royal), properties(:rasberry)]
    beings(:xerxes).properties.should == [properties(:red), properties(:royal), properties(:quixotic)]
    beings(:xerxes).properties.starts_with('r').should == [properties(:red), properties(:royal)]
  end
end