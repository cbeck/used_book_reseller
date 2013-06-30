require File.dirname(__FILE__) + '/../test_helper'
require 'products_controller'

# Re-raise errors caught by the controller.
class ProductsController; def rescue_action(e) raise e end; end

class ProductsControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  fixtures :products, :users, :sellers, :roles, :roles_users, :sellers_users

  def setup
    @controller = ProductsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :aaron
    choose_seller_account
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:products)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_product
    login_as :aaron
    old_count = Product.count
    post :create, :product => {:title => "MyNewProduct" ,
      :description => "yyy" ,
      :price => 1  }
    assert_equal old_count+1, Product.count
    
    assert_redirected_to product_path(assigns(:product))
  end

  def test_should_show_product
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_product
    put :update, :id => 1, :product => {:title => "ScoopyDoopy Product" }
    assert_redirected_to products_path
  end
  
  def test_should_destroy_product
    old_count = Product.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Product.count
    
    assert_redirected_to products_path
  end
  
  private
  def choose_seller_account
    put "/sellers", :id => 2
  end
end
