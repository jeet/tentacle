# require File.dirname(__FILE__) + '/../../spec_helper'
# 
# ModelStubbing.define_models :groups_controller, :copy => :stubbed, :insert => false do
#   model Group do
#     stub :new, :name => 'new group', :host => 'other.test.host', :new_record? => true
#   end
# end
# 
# describe "/sites/new.html.erb" do
#   define_models :groups_controller
#   include SitesHelper
#   
#   before do
#     @site = sites(:new)
#     assigns[:site] = @site
#   end
# 
#   it "should render new form" do
#     render "/groups/new.html.erb"
#     
#     response.should have_tag("form[action=?][method=post]", sites_path) do
#     end
#   end
# end


