class ProductReviewsController < ApplicationController
  before_filter :login_required
  # GET /product_reviews
  # GET /product_reviews.xml
  def index
    @product_reviews = ProductReview.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @product_reviews.to_xml }
    end
  end

  # GET /product_reviews/1
  # GET /product_reviews/1.xml
  def show
    @product_review = ProductReview.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @product_review.to_xml }
    end
  end

  # GET /product_reviews/new
  def new
    @product_review = ProductReview.new
  end

  # GET /product_reviews/1;edit
  def edit
    @product_review = ProductReview.find(params[:id])
  end

  # POST /product_reviews
  # POST /product_reviews.xml
  def create
    @product_review = ProductReview.new(params[:product_review])

    respond_to do |format|
      if @product_review.save
        flash[:notice] = 'ProductReview was successfully created.'
        format.html { redirect_to product_review_url(@product_review) }
        format.xml  { head :created, :location => product_review_url(@product_review) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @product_review.errors.to_xml }
      end
    end
  end

  # PUT /product_reviews/1
  # PUT /product_reviews/1.xml
  def update
    @product_review = ProductReview.find(params[:id])

    respond_to do |format|
      if @product_review.update_attributes(params[:product_review])
        flash[:notice] = 'ProductReview was successfully updated.'
        format.html { redirect_to product_review_url(@product_review) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @product_review.errors.to_xml }
      end
    end
  end

  # DELETE /product_reviews/1
  # DELETE /product_reviews/1.xml
  def destroy
    @product_review = ProductReview.find(params[:id])
    @product_review.destroy

    respond_to do |format|
      format.html { redirect_to product_reviews_url }
      format.xml  { head :ok }
    end
  end
end
