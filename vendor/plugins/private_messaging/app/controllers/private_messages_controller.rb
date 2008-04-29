class PrivateMessagesController < ApplicationController
  before_filter :find_message, :only => [:edit, :update, :destroy]
  before_filter :login_required
  
  def index
    @private_messages = PrivateMessage.paginate(:page => params[:page], :order => 'created_at DESC')
  end
  
  def create
    @private_message = current_profile.private_messages_sent.build(params[:private_message])
    @private_message.recipient_id = params[:private_message][:recipient_id]
    @private_message.save!
    
    begin
      PrivateMessageMailer.deliver_notification(current_profile, @private_message.recipient,
          request.host_with_port, profile_url(@private_message.recipient))
    rescue Net::SMTPServerBusy, Net::SMTPUnknownError, \
      Net::SMTPSyntaxError, Net::SMTPFatalError, TimeoutError => e
      logger.error("error sending email to #{@private_message.recipient.email}: #{e}")
    end
    
    respond_to do |format|
      format.html { redirect_to profile_path(@private_message.recipient_id) }
    end
  end

  def update
    @private_message.attributes = params[:private_message]
    @private_message.recipient_id = params[:private_message][:recipient_id]
    @private_message.save!
    respond_to do |format|
      format.html { redirect_to pm_path }
    end
  end

  def destroy
    recipient_id = @private_message.recipient_id
    @private_message.delete_by! current_profile
    flash[:notice] = "Private message '{title}' was deleted."[:private_message_deleted_message, @private_message.title]
    respond_to do |format|
      format.html do
        redirect_to profile_path(recipient_id)
      end
      format.xml { head 200 }
    end
  end

  protected
    def find_message
      @private_message = PrivateMessage.find params[:id]
    end
  
    def authorized?
      (not ['edit', 'destroy', 'update'].include?(action_name)) ||
          @private_message.editable_by?(current_profile) ||
          (action_name == 'destroy' && @private_message.recipient?(current_profile))
    end
end
