class ProfilesController < ApplicationController
  before_filter :login_required, :only => [:index, :edit, :update]
  before_filter :get_profile, :only => [:show]
  
  def edit
    if params[:id] == 'me'
      @profile = current_user.profile || current_user.build_profile
      respond_to do |format|
        format.html
      end
    else
      redirect_to edit_profile_path('me') 
    end
  end
  
  def update
    @profile = current_user.profile || current_user.build_profile
    
    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to(profile_path('me')) }
      else
        format.html { render :action => "edit", :id => 'me' }
      end
    end
  end
  
  def show
    respond_to do |format|
      format.html
    end
  end
  
  private
    def get_profile
      if params[:id] == 'me'
        @profile = current_user.profile || current_user.build_profile
        @user = current_user
      else
        @user = User.find_by_login(params[:id])
        @profile = @user.profile || @user.build_profile
      end
    end
end
