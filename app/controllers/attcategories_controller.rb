class AttcategoriesController < ApplicationController
  before_filter :admin_required
  
  # GET /attcategories
  # GET /attcategories.xml
  def index
    @attcategories = Attcategory.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attcategories }
    end
  end

  # GET /attcategories/1
  # GET /attcategories/1.xml
  def show
    @attcategory = Attcategory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attcategory }
    end
  end

  # GET /attcategories/new
  # GET /attcategories/new.xml
  def new
    @attcategory = Attcategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attcategory }
    end
  end

  # GET /attcategories/1/edit
  def edit
    @attcategory = Attcategory.find(params[:id])
  end

  # POST /attcategories
  # POST /attcategories.xml
  def create
    @attcategory = Attcategory.new(params[:attcategory])

    respond_to do |format|
      if @attcategory.save
        flash[:notice] = 'Attribute was successfully created.'
        format.html { redirect_to(@attcategory) }
        format.xml  { render :xml => @attcategory, :status => :created, :location => @attcategory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attcategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attcategories/1
  # PUT /attcategories/1.xml
  def update
    @attcategory = Attcategory.find(params[:id])

    respond_to do |format|
      if @attcategory.update_attributes(params[:attcategory])
        flash[:notice] = 'Attribute was successfully updated.'
        format.html { redirect_to(@attcategory) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attcategory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attcategories/1
  # DELETE /attcategories/1.xml
  def destroy
    @attcategory = Attcategory.find(params[:id])
    @attcategory.destroy

    respond_to do |format|
      format.html { redirect_to(attcategories_url) }
      format.xml  { head :ok }
    end
  end
end
