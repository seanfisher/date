class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem and localizate in Application Controller instead
  before_filter :authenticate, :except => [:new, :create, :activate]
  before_filter :admin_required, :except => [:new, :create, :activate]
  
  def authenticate
    unless logged_in?
      redirect_to :controller => "home"
      flash[:error] = I18n.t(:access_denied)
    end
  end

  # render new.rhtml
  def new
    @user = User.new(:invitation_token => params[:invitation_token])
    @user.email = @user.invitation.recipient_email if @user.invitation
  end
  
  def index
    @users = User.all
    
    respond_to do |format|
      format.html
    end
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_back_or_default('/')
      flash[:notice] = I18n.t(:signup_complete_with_activation)
    else
      flash[:error]  = I18n.t(:signup_problem)
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = I18n.t(:signup_complete_and_do_login)
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:warning] = I18n.t(:blank_activation_code)
      redirect_back_or_default('/')
    else 
      flash[:warning]  = I18n.t(:bogus_activation_code, :model => 'user')
      redirect_back_or_default('/')
    end
  end
  
  def make_admin
    user = User.find_by_id(params[:id])
    if user
      user.is_admin = true
      if user.save
        flash[:notice] = "User was sucessfully 'bumped up' to an admin! Hopefully they're trustworthy..."
        redirect_back_or_default(users_path)
      end
    end
  end
  
  #
  # Change user passowrd
  def change_password

  end
  
  #
  # Change user passowrd
  def update
    if User.authenticate(current_user.login, params[:old_password])
        if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
            current_user.password_confirmation = params[:password_confirmation]
            current_user.password = params[:password]
            
            if current_user.save!
                flash[:notice] = "Password successfully updated"
                redirect_to change_password_path
            else
                flash[:error] = "Password not changed"
                render :action => 'change_password'
            end
             
        else
            flash[:warning] = "New Password mismatch" 
            render :action => 'change_password'
        end
    else
        flash[:warning] = "Old password incorrect" 
        render :action => 'change_password'
      end
  end
  
  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find_by_id(params[:id])
    @user.delete

    respond_to do |format|
      format.html { redirect_to(users_path) }
      format.xml  { head :ok }
    end
  end
  
  def show
    @id = params[:id]
    if @id == "change_password"
      redirect_to change_password_path
    end
  end
end
