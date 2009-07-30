# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '916f33cbeb3ac64b93a0f381dc23c7fe'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  include AuthenticatedSystem
  
  protected
  before_filter :set_locale, :get_current_user, :set_theme
  
  def set_locale
    # if this is nil then I18n.default_locale will be used
    I18n.locale = params[:locale] 
  end
  
  def get_current_user
    @current_user = current_user
  end
  
  def set_theme
    if session[:theme_stylesheet].nil?
      Dir.chdir(Rails.root + 'public/stylesheets/themes')
      theme_dirs = Dir.glob("*")
      session[:theme_stylesheet] = @theme_stylesheet = theme_dirs.rand
    else
      @theme_stylesheet = session[:theme_stylesheet]
    end
  end
end
