class GroupsController < ApplicationController
protected
  prepend_before_filter :load_group, :except => [ :index, :new, :create ] # so it doesn't use the group_id method
  def load_group
    @group = Group.find_by_name(params[:id].titleize) or raise ActiveRecord::RecordNotFound
  end
  
public
  
  def index
    @groups = Group.find(:all)
  end
  
  def show
    #@group = Group.find_by_name(params[:id].titleize) or raise ActiveRecord::RecordNotFound
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @group = Group.new
  end
  
  def edit
    #@group = Group.find_by_name(params[:id].titleize)
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    @group = Group.new(params[:group])
    
    if @group.save
      @group.memberships.create :profile_id => current_user.profile.id
      redirect_to group_path(@group)
    else
      render :action => 'new'
    end
  end
  
  def update
    #@group = Group.find_by_name(params[:id].titleize)

    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(group_path(@group)) }
      else
        format.html { render :action => 'edit' }
      end
    end
  end
  
  def destroy
    #@group = Group.find_by_name(params[:id].titleize)
    @group.destroy unless Group.name == 'Default'

    respond_to do |format|
      format.html { redirect_to(root_path) }
    end
  end
  
  rescue_from ActiveRecord::RecordNotFound, :with => proc { |e| redirect_to('/') }
end