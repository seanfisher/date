class ActivitiesController < ApplicationController
  before_filter :login_required, :only => ["new", "create", "edit", "update"]
  before_filter :admin_required, :except => ["new", "index", "create", "show", "edit", "update"]
  
  # GET /activities
  # GET /activities.xml
  def index
    
    @activities = Activity.search(params[:search], params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @activities }
    end
  end

  # GET /activities/1
  # GET /activities/1.xml
  def show
    @activity = Activity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @activity = Activity.new
    @attcategories = Attcategory.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @activity = Activity.find(params[:id])
    @attcategories = Attcategory.find(:all)
  end

  # POST /activities
  # POST /activities.xml
  def create
    @activity = Activity.new(params[:activity])
    @attcategories = Attcategory.find(:all)
    
    @activity.duration =  params[:activity_hours].to_i   * 60
    @activity.duration += params[:activity_minutes].to_i

    respond_to do |format|
      if @activity.save
        flash[:notice] = 'Activity was successfully created.'
        format.html { redirect_to(@activity) }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = Activity.find(params[:id])
    @attcategories = Attcategory.find(:all)
    
    duration =  params[:activity_hours].to_i   * 60
    duration += params[:activity_minutes].to_i
    
    args = params[:activity].merge!({"duration" => duration})
    
    # Work around - initialize attributes to zero every
    # time before filling them back in
    @activity.update_attributes(:actattribute_ids => [])

    respond_to do |format|
      if @activity.update_attributes(args)
        flash[:notice] = 'Activity was successfully updated.'
        format.html { redirect_to(@activity) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end
end
