class RatingsController < ApplicationController
  before_filter :login_required
  # GET /ratings
  # GET /ratings.xml
  def index
    @ratings = Rating.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @ratings.to_xml }
    end
  end

  # GET /ratings/1
  # GET /ratings/1.xml
  def show
    @rating = Rating.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @rating.to_xml }
    end
  end

  # GET /ratings/new
  def new
    @rating = Rating.new
  end

  # GET /ratings/1;edit
  def edit
    @rating = Rating.find(params[:id])
  end

  # POST /ratings
  # POST /ratings.xml
  def create
    @rating = Rating.new(params[:rating])

    respond_to do |format|
      if @rating.save
        flash[:notice] = 'Rating was successfully created.'
        format.html { redirect_to rating_url(@rating) }
        format.xml  { head :created, :location => rating_url(@rating) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @rating.errors.to_xml }
      end
    end
  end

  # PUT /ratings/1
  # PUT /ratings/1.xml
  def update
    @rating = Rating.find(params[:id])

    respond_to do |format|
      if @rating.update_attributes(params[:rating])
        flash[:notice] = 'Rating was successfully updated.'
        format.html { redirect_to rating_url(@rating) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @rating.errors.to_xml }
      end
    end
  end

  # DELETE /ratings/1
  # DELETE /ratings/1.xml
  def destroy
    @rating = Rating.find(params[:id])
    @rating.destroy

    respond_to do |format|
      format.html { redirect_to ratings_url }
      format.xml  { head :ok }
    end
  end
end
