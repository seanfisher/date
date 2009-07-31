require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :activities
  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  # validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  # validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  validates_presence_of :invitation_id, :message => 'is required'
  validates_uniqueness_of :invitation_id

  before_create :make_activation_code, :set_invitation_limit

  attr_accessible :login, :email, :name, :password, :password_confirmation, :invitation_token
  
  def invitation_token
    invitation.token if invitation
  end
  
  def invitation_token=(token)
    self.invitation = Invitation.find_by_token(token)
  end
  
  def preferred_theme
    "drive_in" # only theme right now :)
  end
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  def is_admin?
    self.is_admin
  end
  
  def name
    self.login
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :active, :conditions => ["email = ? OR login = ?",login.downcase,login.downcase] # need to get the salt
    u && u.authenticated?(password) && u.active? ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def destroy
    
  end

  protected
    
    def make_activation_code
        self.activation_code = self.class.make_token
    end
  private
    def set_invitation_limit
      self.invitation_limit = 5
    end

end
