require File.dirname(__FILE__) + '/../test_helper'
require 'forum_groups_controller'

# Re-raise errors caught by the controller.
class ForumGroupsController; def rescue_action(e) raise e end; end

class ForumGroupsControllerTest < Test::Unit::TestCase
  fixtures :forum_groups

  def setup
    @controller = ForumGroupsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:forum_groups)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_forum_group
    old_count = ForumGroup.count
    post :create, :forum_group => { }
    assert_equal old_count+1, ForumGroup.count
    
    assert_redirected_to forum_group_path(assigns(:forum_group))
  end

  def test_should_show_forum_group
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_forum_group
    put :update, :id => 1, :forum_group => { }
    assert_redirected_to forum_group_path(assigns(:forum_group))
  end
  
  def test_should_destroy_forum_group
    old_count = ForumGroup.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ForumGroup.count
    
    assert_redirected_to forum_groups_path
  end
end
