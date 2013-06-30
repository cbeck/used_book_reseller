require File.dirname(__FILE__) + '/../test_helper'
require 'ratings_controller'

# Re-raise errors caught by the controller.
class RatingsController; def rescue_action(e) raise e end; end

class RatingsControllerTest < Test::Unit::TestCase
  fixtures :ratings

  def setup
    @controller = RatingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:ratings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_rating
    old_count = Rating.count
    post :create, :rating => {:name => 'Mediocre', :score => 3 }
    assert_equal old_count+1, Rating.count
    
    assert_redirected_to rating_path(assigns(:rating))
  end

  def test_should_show_rating
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_rating
    put :update, :id => 1, :rating => { :score => 10 }
    assert_redirected_to rating_path(assigns(:rating))
  end
  
  def test_should_destroy_rating
    old_count = Rating.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Rating.count
    
    assert_redirected_to ratings_path
  end
end
