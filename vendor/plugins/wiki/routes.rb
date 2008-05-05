resources :flags
resources :pages, :member => {:revision => :get, :rollback => :get, :lock => :get, :revisions => :get, :diff => :get}, :collection => {:search => :get}
resources :attachments

connect 'menus/:action', :controller => 'menus'

wiki_page 'wiki/:id', :controller => "pages", :action => "show"
connect "wiki", :controller => "pages", :action => "show", :id => "home"