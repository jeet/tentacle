class PrivateMessageMailer < ActionMailer::Base
  def notification(sender, recipient, domain, messages_url, sent_at = Time.now)
    @subject    = "[Beast] You\'ve received a private message from #{sender.display_name}"
    @body       = {:sender => sender, :recipient => recipient, :domain => domain, :messages_url => messages_url}
    @recipients = recipient.email
    @from       = Object.const_defined?(:MAILER_DEFAULT_SENDER) ? MAILER_DEFAULT_SENDER : 'beast@' + domain.split(":").first
    @sent_on    = sent_at
    @headers    = {}
  end
end
