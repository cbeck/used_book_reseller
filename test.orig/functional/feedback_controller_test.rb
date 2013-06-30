require File.dirname(__FILE__) + '/../test_helper'
require 'feedback_controller'

# Re-raise errors caught by the controller.
class FeedbackController; def rescue_action(e) raise e end; end

class FeedbackControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper    
  fixtures :feedback, :line_items, :users

  def setup
    @controller = FeedbackController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :aaron
  end

  def test_should_get_index
    get :index, :line_item_id => 1
    assert_response :success
    assert assigns(:feedback)
  end

  def test_should_get_new
    get :new, :line_item_id => 1
    assert_response :success
  end
  
  def test_should_create_feedback
    old_count = Feedback.count
    post :create, :line_item_id => 2, :feedback => {:feedback => "great", :comment => "very cool dude"}
    assert_equal old_count+1, Feedback.count
    
    assert_redirected_to feedback_path(assigns(:feedback))
  end

  def test_should_show_feedback
    get :show, :line_item_id => 1, :id => 1
    assert_response :success
  end

  def test_should_get_edit # should redirect because not super user
    login_as :quentin
    get :edit, :line_item_id => 1, :id => 1
    assert_response :success
  end
  
  def test_should_not_get_edit
    get :edit, :line_item_id => 1, :id => 1
    assert_response :redirect
  end
  
  def test_should_update_feedback # should redirect because not super user
    login_as :quentin
    put :update, :line_item_id => 1, :id => 1, :feedback => {:feedback => "neato" }
    assert_redirected_to feedback_path(:line_item_id => 1)
    assert assigns(:feedback)
  end
  
  def test_should_not_update_feedback
    put :update, :line_item_id => 1, :id => 1, :feedback => {:feedback => "neato" }
    assert_response :redirect
  end
  
  def test_should_destroy_feedback
    login_as :quentin
    old_count = Feedback.count
    delete :destroy, :line_item_id => 1, :id => 1
    assert_equal old_count-1, Feedback.count    
    assert_redirected_to line_item_path
  end
  
  def test_should_not_destroy_feedback
    delete :destroy, :line_item_id => 1, :id => 1
    assert_response :redirect
  end
  
end
