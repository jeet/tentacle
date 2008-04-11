ModelStubbing.define_models do
  time 2007, 6, 15

  model Group do
    stub :name => 'default'
  end

  model User do
    stub :login => 'normal-user', :state => 'active',
      :crypted_password => '00742970dc9e6319f8019fd54864d3ea740f04b1',
      :token => 'foo-bar', :token_expires_at => current_time + 5.days,
      :activation_code => '8f24789ae988411ccf33ab0c30fe9106fab32e9b', :activated_at => current_time - 4.days, :posts_count => 3, :permalink => 'normal-user'
  end
  
  model Forum do
    stub :name => "Default", :topics_count => 2, :posts_count => 2, :position => 1, :state => 'public', :group => all_stubs(:group), :permalink => 'default'
  end
  
  model Topic do
    stub :forum => all_stubs(:forum), :user => all_stubs(:user), :title => "initial", :hits => 0, :sticky => 0, :posts_count => 1,
      :last_post_id => 1000, :last_updated_at => current_time - 5.days, :group => all_stubs(:group), :permalink => 'initial'
    stub :other, :title => "Other", :last_updated_at => current_time - 4.days, :permalink => 'other'
    stub :other_forum, :forum => all_stubs(:other_forum)
  end

  model Post do
    stub :topic => all_stubs(:topic), :forum => all_stubs(:forum), :user => all_stubs(:user), :body => 'initial', :created_at => current_time - 5.days, :group => all_stubs(:group)
    stub :other, :topic => all_stubs(:other_topic), :body => 'other', :created_at => current_time - 13.days
    stub :other_forum, :forum => all_stubs(:other_forum), :topic => all_stubs(:other_forum_topic)
  end
  
  model Moderatorship do
    stub :user => all_stubs(:user), :forum => all_stubs(:other_forum)
  end
  model Monitorship
end

ModelStubbing.define_models :users do 
  model User do
    stub :admin,     :login => 'admin-user',     :email => 'admin-user@example.com', :remember_token => 'blah'
    stub :pending,   :login => 'pending-user',   :email => 'pending-user@example.com',   :state => 'pending', :activated_at => nil, :remember_token => 'asdf'
    stub :suspended, :login => 'suspended-user', :email => 'suspended-user@example.com', :state => 'suspended', :remember_token => 'dfdfd'
  end
end

ModelStubbing.define_models :stubbed, :insert => false