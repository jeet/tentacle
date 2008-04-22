class MembershipsController < ApplicationController
  before_filter :login_required

  # Simple create method. Doesn't use invitations or confirmation.
  def create
    membership = current_profile.memberships.create :group_id => params[:group_id]
    flash[:notice] = "You have joined the group!"
    redirect_to membership.group
  end
  
  def destroy
    membership = Membership.find(params[:id])
    if membership.member == current_profile or
       current_profile.admin? or # site admin
       Membership.join_from(membership.group, current_profile).admin? # group owner
       
      membership.destroy
    end
    redirect_to membership.group
  end
end