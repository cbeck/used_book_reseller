require File.dirname(__FILE__) + '/../test_helper'
require 'cart_items_controller'

# Re-raise errors caught by the controller.
class CartItemsController; def rescue_action(e) raise e end; end

class CartItemsControllerTest < Test::Unit::TestCase
  fixtures :products
  
  def setup
    @controller = CartItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @cart = Cart.new
    @rails = products(:rails_book)
    @ruby = products(:ruby_book)
  end
 
 # functionality not supported yet
 # def test_should_get_index
 #   get :index
 #   assert_response :success
 #   assert assigns(:cart_items)
 # end

  def test_should_create_cart_item
    old_count = @cart.items.size
    assert old_count == 0
    post :create, {:product_id => @ruby}, {:cart => @cart}
    assert_equal old_count+1, @cart.items.size
    assert assigns(:current_item)
    post :create,  {:product_id => @rails}, {:cart => @cart}
    post :create, {:product_id => @rails}, {:cart => @cart}
    assert_equal old_count+2, @cart.items.size
    current_item = @cart.items.find {|item| item.product == @rails}
    assert_equal current_item.quantity, 2    
  end

  #def test_should_update_cart_item
  #  put :update, :id => 1, :cart_item => { }
  #  assert_redirected_to cart_item_path(assigns(:cart_item))
  #end
  
  # functionality not supported yet
  #def test_should_destroy_cart_item
  #  old_count = CartItem.count
  #  delete :destroy, :id => 1
  #  assert_equal old_count-1, CartItem.count
  #  
  #  assert_redirected_to cart_items_path
  #end
end
