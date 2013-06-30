class Admin::ForumPostsController < ApplicationController
  before_filter :login_required
  before_filter :find_forum
  
  # GET /forums/1/forum_posts
  # GET /forums/1/forum_posts.xml
  def index
    @forum_posts = @forum.forum_posts.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @forum_posts.to_xml }
    end
  end

  # GET /forums/1/forum_posts/1
  # GET /forums/1/forum_posts/1.xml
  def show
    @forum_post = ForumPost.find(params[:id]) # want to be able to pull up post without knowing forum

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @forum_post.to_xml }
    end
  end

  # GET /forums/1/forum_posts/new
  def new
    @forum_post = ForumPost.new
  end

  # GET /forums/1/forum_posts/1;edit
  def edit
    @forum_post = ForumPost.find(params[:id])
  end

  # POST /forums/1/forum_posts
  # POST /forums/1/forum_posts.xml
  def create
    @forum_post = ForumPost.new(params[:forum_post])
    @forum_post.forum_id = @forum

    respond_to do |format|
      if @forum_post.save
        flash[:notice] = 'ForumPost was successfully created.'
        format.html { redirect_to forum_post_url(:forum_id => @forum, :id => @forum_post) }
        format.xml  { head :created, :location => forum_post_url(:forum_id => @forum, :id => @forum_post) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @forum_post.errors.to_xml }
      end
    end
  end

  # PUT /forums/1/forum_posts/1
  # PUT /forums/1/forum_posts/1.xml
  def update
    @forum_post = ForumPost.find(params[:id])

    respond_to do |format|
      if @forum_post.update_attributes(params[:forum_post])
        flash[:notice] = 'ForumPost was successfully updated.'
        format.html { redirect_to forum_post_url(:forum_id => @forum, :id => @forum_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @forum_post.errors.to_xml }
      end
    end
  end

  # DELETE /forums/1/forum_posts/1
  # DELETE /forums/1/forum_posts/1.xml
  def destroy
    @forum_post = ForumPost.find(params[:id])
    @forum_post.destroy

    respond_to do |format|
      format.html { redirect_to forum_posts_url(:forum_id => @forum) }
      format.xml  { head :ok }
    end
  end
  
  # PUT /forums/1/forum_posts/1;reply
  # PUT /forums/1/forum_posts/1.xml;reply
  def reply
    reply_to = ForumPost.find(params[:id])
    @forum_post = ForumPost.new(:parent_id => reply_to.id)
    render :action => :new
  end
  
  private
  
  def find_forum
    @forum_id = params[:forum_id]
    redirect_to forums_url unless @forum_id
    @forum = Forum.find(@forum_id)
  end
end