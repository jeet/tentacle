require File.dirname(__FILE__) + '/../test_helper'

context "User" do
  specify "should find users by login" do
    User.find_all_by_logins(%w(rick)).should == [users(:rick)]
    User.find_all_by_logins(%w(rick2)).should == []
  end
  
  specify "should authenticate with httpbasic auth" do
    u = User.new :password => 'monkey'
    u.send :encrypt_password
    u.crypted_password.should.not.be.nil
    User.expects(:find_by_login).with('rick').returns(u)
    User.authenticate('rick', 'monkey').should.not.be.nil
  end
  
  specify "should require valid crypted pass" do
    u = User.new :password => 'monkey'
    u.send :encrypt_password
    u.crypted_password.should.not.be.nil
    User.expects(:find_by_login).with('rick').returns(u)
    User.authenticate('rick', 'chicken').should.be.nil
  end
end

context "User with basic authentication" do
  before do
    @user       = User.new :password => 'foo', :login => 'bob'
    @old_scheme = Tentacle.authentication_scheme
    @old_realm  = Tentacle.authentication_realm
    Tentacle.authentication_scheme = 'basic'
    Tentacle.authentication_realm  = 'foo'
  end
  
  after do
    Tentacle.authentication_scheme = @old_scheme
    Tentacle.authentication_realm  = @old_realm
  end
  
  specify "should encrypt password" do
    TokenGenerator.expects(:generate_simple).with(2).returns('ab')
    @user.encrypt_password!
    @user.crypted_password.should == 'abQ9KY.KfrYrc'
  end
  
  specify "should decrypt password" do
    @user.encrypt_password!
    @user.password_matches?('foo').should == true
  end
end

context "User with plain authentication" do
  before do
    @user       = User.new :password => 'foo', :login => 'bob'
    @old_scheme = Tentacle.authentication_scheme
    @old_realm  = Tentacle.authentication_realm
    Tentacle.authentication_scheme = 'plain'
    Tentacle.authentication_realm  = 'foo'
  end
  
  after do
    Tentacle.authentication_scheme = @old_scheme
    Tentacle.authentication_realm  = @old_realm
  end
  
  specify "should encrypt password" do
    @user.encrypt_password!
    @user.crypted_password.should == 'foo'
  end
  
  specify "should decrypt password" do
    @user.encrypt_password!
    @user.password_matches?('foo').should == true
  end
end

context "User with md5 authentication" do
  before do
    @user       = User.new :password => 'foo', :login => 'bob'
    @old_scheme = Tentacle.authentication_scheme
    @old_realm  = Tentacle.authentication_realm
    Tentacle.authentication_scheme = 'md5'
    Tentacle.authentication_realm  = 'bar'
  end
  
  after do
    Tentacle.authentication_scheme = @old_scheme
    Tentacle.authentication_realm  = @old_realm
  end
  
  specify "should encrypt password" do
    @user.encrypt_password!
    @user.crypted_password.should == Digest::MD5::hexdigest("bob:bar:foo")
  end
  
  specify "should decrypt password" do
    @user.encrypt_password!
    @user.password_matches?('foo').should == true
  end
end
