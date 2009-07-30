class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.send_later(:deliver_signup_notification, user)
  end

  def after_save(user)
    # The welcome email
    # UserMailer.send_later(:deliver_activation, user) if user.recently_activated?
  end
end
