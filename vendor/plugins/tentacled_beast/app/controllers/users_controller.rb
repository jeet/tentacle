class UsersController
  before_filter :admin_required, :only => [:suspend, :unsuspend, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :purge]
  before_filter :login_required, :only => [:settings]
  
  def index
    @users = current_group.users.paginate :all, :page => current_page
  end

  # render new.rhtml
  def new
  end

  def settings
    @user = current_user
    render :action => "edit"
  end

  def activate
    self.current_user = params[:activation_code].blank? ? :false : current_group.all_users.find_in_state(:first, :pending, :conditions => {:activation_code => params[:activation_code]})
    if logged_in?
      current_user.activate!
      flash[:notice] = "Signup complete!"
    end
    redirect_back_or_default('/')
  end

  def suspend
    @user.suspend! 
    flash[:notice] = "User was suspended."
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    flash[:notice] = "User was unsuspended."
    redirect_to users_path
  end

  def destroy
    @user.delete!
    redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

protected
  def find_user
    @user = if admin?
      current_group.all_users.find_by_permalink(params[:id])
    else
      current_group.users.find_by_permalink(params[:id])
    end or raise ActiveRecord::RecordNotFound
  end
  
  def authorized?
    admin? || params[:id].blank? || @user == current_user
  end
end
