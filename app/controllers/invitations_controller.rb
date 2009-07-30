class InvitationsController < ApplicationController
  before_filter :admin_required, :except => [:new, :create]
  
  # GET /invitations
  # GET /invitations.xml
  def index
    @invitations = Invitation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invitations }
    end
  end

  # GET /invitations/new
  # GET /invitations/new.xml
  def new
    @invitation = Invitation.new
    
    # exception for private beta
    unless current_user
      render "home/private_beta" and return
    end

    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  # GET /invitations/send/1
  def send_invite
    @invitation = Invitation.find(params[:id])
    
    UserMailer.send_later(:deliver_admin_invitation, @invitation, signup_url(@invitation.token)) if @invitation.requested?
    UserMailer.send_later(:deliver_invitation, @invitation, signup_url(@invitation.token)) if !@invitation.requested?
    flash[:notice] = I18n.t("email_sent")
    redirect_back_or_default(invitations_path)
  end

  # POST /invitations
  # POST /invitations.xml
  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.sender = current_user

    respond_to do |format|
      if @invitation.save
        if logged_in?
          UserMailer.send_later(:deliver_invitation, @invitation, signup_url(@invitation.token))
          flash[:notice] = I18n.t("invitation_sent", :num_left => @invitation.sender.invitation_limit)
        else
          flash[:notice] = I18n.t("invitation_signup")
        end
        format.html { redirect_to('/') }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1
  # DELETE /invitations/1.xml
  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to(invitations_url) }
      format.xml  { head :ok }
    end
  end
end
