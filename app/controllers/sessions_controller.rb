# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController  
  # render new.rhtml
  def new
  end

  def show
    redirect_back_or_default('/')
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      session[:theme_stylesheet] = @theme_stylesheet = user.preferred_theme unless user.preferred_theme.nil?
      redirect_back_or_default('/')
      flash[:notice] = I18n.t(:logged_in)
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      @login.blank? ? flash[:error] = I18n.translate(:login_missing) : flash[:error] = I18n.translate(:login_failed, :login => @login)
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = I18n.t(:logged_out)
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:warning] = I18n.t(:login_failed, :login => params[:login]) unless !params[:login].nil?
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
