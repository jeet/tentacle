resources :sites, :moderatorships

resources :forums, :has_many => :posts do |forum|
  forum.resources :topics do |topic|
    topic.resources :posts
    topic.resource :monitorship
  end
  forum.resources :posts
end

resources :posts, :collection => {:search => :get}

# resources :users, :member => { :suspend   => :put,
#                                    :settings  => :get,
#                                    :unsuspend => :put,
#                                    :purge     => :delete },
#                       :has_many => [:posts]

activate '/activate/:activation_code', :controller => 'users',    :action => 'activate', :activation_code => nil
settings '/settings',                  :controller => 'users',    :action => 'settings'
