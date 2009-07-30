class Invitation < ActiveRecord::Base
  belongs_to :sender, :class_name => 'User'
  has_one :recipient, :class_name => 'User'
  
  validates_presence_of :recipient_email
  validate :recipient_is_not_registered
  validate :sender_has_invitations, :if => :sender
  validates_presence_of :recipient_name, :if => :sender
  validates_length_of :personal_message, :maximum => 300, :message => "should be less than {{count}} characters.", :if => :sender
  
  before_create :generate_token
  before_create :decrement_sender_count, :if => :sender
  
  def used?
    self.recipient && self.recipient.is_a?(User)
  end
  
  def requested?
    !self.sender && !self.sender.is_a?(User)
  end
  
  def sent?
    self.sent_at
  end
  
private
  
  def recipient_is_not_registered
    errors.add :recipient_email, I18n.t("already_registered") if User.find_by_email(recipient_email)
  end
  
  def sender_has_invitations
    unless sender.invitation_limit > 0
      errors.add_to_base I18n.t("reached_invitation_limit")
    end
  end
  
  def generate_token
    self.token = Digest::SHA1.hexdigest([Time.now, rand, "$@!SecretSalt"].join)
  end
  
  def decrement_sender_count
    sender.decrement! :invitation_limit
  end
  
end
