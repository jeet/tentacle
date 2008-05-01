ModelStubbing.define_models do
  time 2007, 6, 15

  model Group do
    stub :name => 'default'
  end

  model User do
    stub :login => 'normal-user', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1'
    stub :rick, :login => 'rick', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1', :admin => true
    stub :virginia, :login => 'virginia', :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1'
  end
  
  model Profile do
    stub :user => all_stubs(:user), :first_name => "Addy", :last_name => "McAdmin", :website => "This one", :about => "o hai.", :email => "emailzz@zz.com", :permalink => "un-deet"
    stub :rick, :user => all_stubs(:rick_user), :first_name => "Rick", :last_name => "Olson", :website => "This one", :about => "o hai.", :email => "emailer@rick.com", :permalink => "un-deet"
    stub :virginia, :user => all_stubs(:virginia_user), :first_name => "Virginia", :last_name => "LeBruege", :website => "This one", :about => "o hai.", :email => "virgie@brown.com", :permalink => "un-deet"
  end
  
  model PrivateMessage do
    stub :sender => all_stubs(:virginia_profile), :recipient => all_stubs(:rick_profile), :title => "Hello", :body => "Well, hello.", :sender_deleted => false, :recipient_deleted => false, :created_at => Time.now
    stub :other_people, :sender => all_stubs(:profile), :recipient => all_stubs(:virginia_profile), :title => "Re: Hello"
    stub :other, :sender => all_stubs(:rick_profile), :recipient => all_stubs(:virginia_profile), :title => "Re: Hello"
    stub :sender_deleted, :sender_deleted => true
    stub :recipient_deleted, :recipient_deleted => true
  end
end

ModelStubbing.define_models :stubbed, :insert => false