class UserMailer < ActionMailer::Base
  URL = "http://datenightout.no-ip.org"
  SITE_TITLE = I18n.t(:site_title)
  def signup_notification(user)
    setup_email(user)
    @subject    = I18n.t(:activation_required_email_subject)
  
    @body[:url]  = URL+"/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += I18n.t(:activation_complete_email_subject)
    @body[:url]  = URL
  end
  
  def invitation(invitation, signup_url)
    @sender_name = invitation.sender.login
    subject     invitation.recipient_name+", you're invited by "+@sender_name+" to try "+SITE_TITLE+"!"
    recipients  invitation.recipient_email
    from        "datenightout.team@gmail.com"
    body        :invitation => invitation, :signup_url => URL+signup_path(invitation.token)
    invitation.update_attribute(:sent_at, Time.now)
  end
  
  def admin_invitation(invitation, signup_url)
    subject     "Your invitation to "+SITE_TITLE+"!"
    recipients  invitation.recipient_email
    from        "datenightout.team@gmail.com"
    body        :invitation => invitation, :signup_url => URL+signup_path(invitation.token)
    invitation.update_attribute(:sent_at, Time.now)
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "datenightout.team@gmail.com"
      @subject     = "Date Night Out "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
