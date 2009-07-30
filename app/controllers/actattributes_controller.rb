class ActattributesController < ApplicationController
  before_filter :admin_required
  
  # GET /actattributes
  # GET /actattributes.xml
  def index
    @actattributes = Actattribute.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @actattributes }
    end
  end

  # GET /actattributes/1
  # GET /actattributes/1.xml
  def show
    @actattribute = Actattribute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @actattribute }
    end
  end

  # GET /actattributes/new
  # GET /actattributes/new.xml
  def new
    @actattribute = Actattribute.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @actattribute }
    end
  end

  # GET /actattributes/1/edit
  def edit
    @actattribute = Actattribute.find(params[:id])
  end

  # POST /actattributes
  # POST /actattributes.xml
  def create
    @actattribute = Actattribute.new(params[:actattribute])

    respond_to do |format|
      if @actattribute.save
        flash[:notice] = 'Attribute was successfully created.'
        format.html { redirect_to(@actattribute) }
        format.xml  { render :xml => @actattribute, :status => :created, :location => @actattribute }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @actattribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /actattributes/1
  # PUT /actattributes/1.xml
  def update
    @actattribute = Actattribute.find(params[:id])

    respond_to do |format|
      if @actattribute.update_attributes(params[:actattribute])
        flash[:notice] = 'Attribute was successfully updated.'
        format.html { redirect_to(@actattribute) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @actattribute.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /actattributes/1
  # DELETE /actattributes/1.xml
  def destroy
    @actattribute = Actattribute.find(params[:id])
    @actattribute.destroy

    respond_to do |format|
      format.html { redirect_to(actattributes_url) }
      format.xml  { head :ok }
    end
  end
end
