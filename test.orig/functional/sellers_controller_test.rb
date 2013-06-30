require File.dirname(__FILE__) + '/../test_helper'
require 'sellers_controller'

# Re-raise errors caught by the controller.
class SellersController; def rescue_action(e) raise e end; end

class SellersControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper  
  fixtures :users, :sellers, :roles, :roles_users, :sellers_users

  def setup
    @controller = SellersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin    
  end

  def test_should_get_index
    login_as :quentin
    get :index
    assert_response :success
    assert assigns(:sellers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_seller
    old_count = Seller.count
    login_as :quentin  
    post :create, :seller => { :name => 'Greg' }
    assert_equal old_count+1, Seller.count
    
    assert_redirected_to seller_path(assigns(:seller))
  end

  def test_should_show_seller
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_seller
    put :update, :id => 1, :seller => { :name => 'Bingo'}
    assert_redirected_to seller_path(assigns(:seller))
  end
  
  def test_should_destroy_seller
    old_count = Seller.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Seller.count
    
    assert_redirected_to sellers_path
  end
end
