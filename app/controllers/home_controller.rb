class HomeController < ApplicationController
  def sub_layout
    "home"
  end
  
  def private_beta
    @invitation = Invitation.new(params[:invitation])
    
    respond_to do |format|
      if request.post? && @invitation.save
        flash[:notice] = I18n.t("invitation_signup")
        format.html { redirect_to('/') }
      else
        format.html { render :action => "private_beta" }
        format.xml  { render :xml => @invitation.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def index
    @featured_activity = Activity.random || Activity.new
    respond_to do |format|
      format.html
      format.js do
        render :partial => "activity_medium", :locals => {:activity => @featured_activity}
      end
    end
  end

end
