resources :profiles

connect 'profiles/me', :controller => 'profiles', :action => 'update', :method => :put
connect 'profiles/me/edit', :controller => 'profiles', :action => 'edit'
