class Admin::FeedbackController < ApplicationController
  before_filter :login_required
  require_role :admin
  before_filter :find_line_item
  
  # GET /line_items/1/feedback
  # GET /line_items/1/feedback.xml
  def index    
    @feedback = @line_item.feedback
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @feedback.to_xml }
    end
  end

  # GET /line_items/1/feedback/1
  # GET /line_items/1/feedback/1.xml
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @feedback.to_xml }
    end
  end

  # GET /line_items/1/feedback/new
  def new
    @feedback = Feedback.new
  end

  # GET /line_items/1/feedback/1;edit
  def edit
    @feedback = Feedback.find(params[:id])
  end

  # POST /line_items/1/feedback
  # POST /line_items/1/feedback.xml
  def create
    @feedback = Feedback.new(params[:feedback]) 
    @feedback.line_item = @line_item   
    respond_to do |format|
      if @feedback.save
        flash[:notice] = 'Feedback was successfully created.'
        format.html { redirect_to feedback_url(@feedback) }
        format.xml  { head :created, :location => feedback_url(@feedback) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feedback.errors.to_xml }
      end
    end
  end

  # PUT /line_items/1/feedback/1
  # PUT /line_items/1/feedback/1.xml
  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        flash[:notice] = 'Feedback was successfully updated.'
        format.html { redirect_to feedback_url(:line_item_id => @line_item, :id => @feedback) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors.to_xml }
      end
    end
  end

  # DELETE /line_items/1/feedback/1
  # DELETE /line_items/1/feedback/1.xml
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    
    respond_to do |format|
      format.html { redirect_to line_item_url(@line_item) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def find_line_item
    @line_item_id = params[:line_item_id]
    redirect_to line_items_url unless @line_item_id
    @line_item = LineItem.find(@line_item_id)
  end
end