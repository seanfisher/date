module InvitationsHelper
  def inv_sender(invitation)
    invitation.sender ? html_escape(invitation.sender.login) : "Self Requested"
  end
  
  def inv_time_sent_ago(invitation)
    invitation.sent_at ? html_escape(time_ago_in_words(invitation.sent_at)) + " ago" : "Never"
  end
end
