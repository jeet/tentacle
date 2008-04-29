module PrivateMessagesHelper

  def private_message_link(profile, msg=default_private_message_link_text)
    if logged_in? and current_profile.id != profile.id
      link_to_function(msg, "PrivateMessageForm.show(#{profile.id})")
    else
      ''
    end
  end
  
  def private_message_form
    render(:partial => 'private_messages/new_form') if logged_in?
  end
  
  # renders a link to send a private message to a profile
  def private_message_for(profile, msg=default_private_message_link_text)
    return unless logged_in?
    private_message_link(profile) + private_message_form
  end
  
  # renders a list of private messages
  def private_messages(context_profile = nil, opts={})
    return unless logged_in?
    
    count = if current_profile.id == context_profile.id
      current_profile.private_messages_count
    else
      current_profile.private_messages_with_profile_count(context_profile)
    end
    
    if count.zero?
      content_tag('p', (opts[:no_messages_message]||'No private messages found.'[]))

    else
      private_messages = paginate(params[:page] || 1, PrivateMessage.per_page, count) do |offset, limit|
        find_options = {:include => :sender, :offset => offset, :limit => limit}
        if current_profile.id == context_profile.id
          current_profile.private_messages(find_options)
        else
          current_profile.private_messages_with_profile(context_profile, find_options)
        end
      end
      
      title = if opts[:title]
      elsif current_profile.id != context_profile.id
        'You Private Messages with {profile}'[:private_messages_with_profile, context_profile.display_name]
      else
        'Private Messages'[:private_messages]
      end
      render :partial => 'private_messages/list', :locals => {:private_messages => private_messages,
          :title => title, :target_profile => context_profile}
    end
  end
  
  protected
    def default_private_message_link_text
      'Send this profile a private message'[]
    end
    
    def paginate(page, per_page, total, &block)
      returning WillPaginate::Collection.new(page, per_page, total) do |pager|
        pager.replace block.call(pager.offset, pager.per_page)
      end  
    end

end
