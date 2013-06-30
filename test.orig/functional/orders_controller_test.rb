require File.dirname(__FILE__) + '/../test_helper'
require 'orders_controller'

# Re-raise errors caught by the controller.
class OrdersController; def rescue_action(e) raise e end; end

class OrdersControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper
  fixtures :orders, :products, :users

  def setup
    @controller = OrdersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @cart = Cart.new
    @rails = products(:rails_book)
    @ruby = products(:ruby_book)
    @cart.add_product(@rails)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:orders)
  end

  def test_should_get_redirected_to_index
    get :new
    assert_redirected_to :controller => 'site', :action => :index
  end
  
  def test_should_get_redirected_to_new_session    
    get :new, {}, :cart => @cart
    assert_redirected_to login_path
  end
  
  def test_should_get_new
    @user = users(:quentin) 
    get :new, {}, {:cart => @cart, :user => @user }
    assert_response :success
  end
  
  def test_should_create_order
    old_count = Order.count
    post :create, 
        :order => {:name => 'fred tester', :email => 'fred@tester.com', :address_line_1 => '111 Done St.', :pay_type => 'cc' }, 
        :cart => @cart
    assert_equal old_count+1, Order.count    
    assert_redirected_to :controller => 'site', :action => :index
  end

  def test_should_show_order
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_order
    put :update, :id => 1, :order => { }
    assert_redirected_to order_path(assigns(:order))
  end
  
  def test_should_destroy_order
    old_count = Order.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Order.count
    
    assert_redirected_to orders_path
  end
end
