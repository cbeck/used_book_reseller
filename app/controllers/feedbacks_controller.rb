class FeedbacksController < ApplicationController
  before_filter :login_required
  before_filter :activate_tab, :sell_navigation, :set_current_item
  before_filter :find_seller, :only => :index    
  
  # GET /line_items/1/feedback
  # GET /line_items/1/feedback.xml
  def index  
    @feedback = @seller.feedback
    
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
    @line_item = current_member.line_items.find(params[:line_item_id])
  end

  # POST /line_items/1/feedback
  # POST /line_items/1/feedback.xml
  def create
    @feedback = Feedback.new(params[:feedback]) 
    @line_item = current_member.line_items.find(params[:line_item_id])
    @feedback.line_item = @line_item   
    respond_to do |format|
      if @feedback.save
        flash[:notice] = 'Feedback was successfully created.'
        format.html { redirect_to feedback_url(@feedback) }
        format.js 
        format.xml  { head :created, :location => feedback_url(@feedback) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feedback.errors.to_xml }
      end
    end
  end
  
  def edit
    @feedback = Feedback.find(params[:id])
    @line_item = @feedback.line_item
    respond_to do |format|
      if current_member.line_items.include? @line_item
        format.html
      else
        flash[:notice] = 'You may not edit that feedback - it is not yours.'
        format.html {redirect_to member_path(current_member)}
      end
    end
    
  end
  
  def update
    @feedback = Feedback.find(params[:id])
    @line_item = current_member.line_items.find(params[:line_item_id])
    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        flash[:notice] = 'Feedback was successfully updated.'
        format.html { redirect_to feedback_url(@feedback) }
        format.xml  { head :created, :location => feedback_url(@feedback) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors.to_xml }
      end
    end
  end
  
  private
  
  def activate_tab
    @active_tab = "sell_tab"
  end
  
  def set_current_item
    @current_item = "my_feedback"
  end
  
end
