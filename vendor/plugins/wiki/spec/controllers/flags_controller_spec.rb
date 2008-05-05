require File.dirname(__FILE__) + "/../spec_helper"

describe FlagsController, "a user not logged in" do
  fixtures :groups, :users, :pages
  integrate_views
  
  before do
    controller.stub!(:logged_in?).and_return false
    controller.stub!(:current_user).and_return :false
  end
  
  %w[index new].each do |action|
     it "#{action} should deny access" do
       get action
       assigns[:message].should == "You must be logged to access this page."
     end
   end

  it 'can not flag something' do
    post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
    assigns[:message].should == "You must be logged to access this page."
  end
  
  it 'can not delete' do
    delete :destroy, :id => "1"
    assigns[:message].should == "You must be logged to access this page."
  end
end

describe FlagsController, "a user logged in as normal user" do
  fixtures :groups, :pages, :page_versions, :users, :profiles
  integrate_views
  
  before do
    # Mocking this was a bitch.
    @user = users(:jeremy)
    @profile = profiles(:jeremy_profile)
    
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return @user
  end
  
  it "does not render 'index'" do
    get :index
    assigns[:message].should == "You must be an administrator to visit this page."
  end
  
  it 'canflag something' do
    lambda {
      post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
      response.should redirect_to('pages/hai')
    }.should change(Flag, :count).by(1)
  end
  it 'can not flag same page twice' do
    post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
    lambda {
      post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
      #flash[:notice].should == "You already flagged this content!"
    }.should_not change(Flag, :count)
  end
  
  it "render 'new'" do
    get :new, :flaggable_type => 'Page', :flaggable_id => 1
    response.should be_success
    response.should render_template('flags/_flag.html.erb')
  end
  
  it "render / with error if flaggable_type is not found" do
    get :new, :flaggable_type => 'NotFound', :flaggable_id => 1
    response.should_not be_success
    response.should redirect_to('/')
    #flash[:error].should_not be_empty
  end

  it "can delete a page" do
    flag = @profile.flags.create({ :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' })
    lambda do
      delete :destroy, :id => flag.id
      response.should redirect_to('flags')
    end.should change(Flag, :count)
  end
end


describe FlagsController, "a user logged in as admin" do
  fixtures :groups, :pages, :page_versions, :users, :profiles
  integrate_views
  
  before do
    @user = users(:admin)
    @profile = profiles(:admin_profile)
    controller.stub!(:require_login)
    controller.stub!(:logged_in?).and_return true
    controller.stub!(:current_user).and_return @user
  end
  
  it "renders 'index'" do
    get :index
    response.should be_success
    response.should render_template("index")    
  end
  
  it 'can flag something' do
    lambda {
      post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
      response.should redirect_to('pages/hai')
    }.should change(Flag, :count).by(1)
  end
  
  it "render 'new'" do
    get :new, :flaggable_type => 'Page', :flaggable_id => 1
    response.should be_success
    response.should render_template("flags/_flag.html.erb")
  end
  it 'can not flag same page twice' do
    post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated'}
    lambda {
      post :create, :flag => { :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' }
      #flash[:notice].should == "You already flagged this content!"
    }.should_not change(Flag, :count)
  end
  it "render / with error if flaggable_type is not found" do
    get :new, :flaggable_type => 'NotFound', :flaggable_id => 1
    response.should_not be_success
    response.should redirect_to('/')
    #flash[:error].should_not be_empty
  end
  it "can delete a page" do
    flag = @profile.flags.create({ :flaggable_type => 'Page', :flaggable_id => 1, :reason => 'outdated' })
    lambda do
      delete :destroy, :id => flag.id
      response.should redirect_to('flags')
    end.should change(Flag, :count)
  end
  
end

