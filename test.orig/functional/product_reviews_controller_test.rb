require File.dirname(__FILE__) + '/../test_helper'
require 'product_reviews_controller'

# Re-raise errors caught by the controller.
class ProductReviewsController; def rescue_action(e) raise e end; end

class ProductReviewsControllerTest < Test::Unit::TestCase
  fixtures :users, :ratings, :product_reviews

  def setup
    @controller = ProductReviewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:product_reviews)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_product_review
    old_count = ProductReview.count
    post :create, :product_review => {
      :isbn => '12222-11-11111',
      :name => 'Another Great Review',
      :author => 'Mr Fister',
      :publisher => 'Pragmatic Programmers',
      :content => 'This thing is great',
      :user_id => users(:quentin),
      :rating_id => ratings(:good) }
    assert_equal old_count+1, ProductReview.count
    
    assert_redirected_to product_review_path(assigns(:product_review))
  end

  def test_should_show_product_review
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_product_review
    put :update, :id => 1, :product_review => {:content => 'On second thought, its bad', :rating_id => ratings(:bad) }
    assert_redirected_to product_review_path(assigns(:product_review))
  end
  
  def test_should_destroy_product_review
    old_count = ProductReview.count
    delete :destroy, :id => 1
    assert_equal old_count-1, ProductReview.count
    
    assert_redirected_to product_reviews_path
  end
end
