require File.dirname(__FILE__) + '/../test_helper'
require 'forum_posts_controller'

# Re-raise errors caught by the controller.
class ForumPostsController; def rescue_action(e) raise e end; end

class ForumPostsControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  fixtures :forum_posts, :users, :forums

  def setup
    @controller = ForumPostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :aaron
  end

  def test_should_get_index
    get :index, :forum_id => 1
    assert_response :success
    assert assigns(:forum_posts)
  end

  def test_should_get_new
    get :new, :forum_id => 1
    assert_response :success
  end
  
  def test_should_create_forum_post
    old_count = ForumPost.count
    post :create, :forum_id => forums(:general_forum),
      :forum_post => {:user_id => users(:quentin).id,
        :subject => 'Subject',
        :body => 'Body body, wanna ....'}
    assert_equal old_count+1, ForumPost.count
    
    assert_response :redirect
    assert assigns(:forum_post)
  end

  def test_should_show_forum_post
    get :show, :forum_id => 1, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :forum_id => 1, :id => 1
    assert_response :success
  end
  
  def test_should_update_forum_post
    put :update, :forum_id => 1, :id => 1, :forum_post => {:subject => 'New Subject' }
    assert_response :redirect
    assert assigns(:forum_post)
  end
  
  def test_should_destroy_forum_post
    login_as :quentin
    old_count = ForumPost.count
    delete :destroy, :forum_id => 1, :id => 1
    assert_equal old_count-1, ForumPost.count
    
    assert_response :redirect
  end
end
