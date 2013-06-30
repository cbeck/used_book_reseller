require File.dirname(__FILE__) + '/../test_helper'
require 'line_items_controller'

# Re-raise errors caught by the controller.
class LineItemsController; def rescue_action(e) raise e end; end

class LineItemsControllerTest < Test::Unit::TestCase
  fixtures :line_items, :orders, :products 

  def setup
    @controller = LineItemsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @rails = products(:rails_book)
    @rails_order = orders(:rails_book_order)
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:line_items)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_line_item
    old_count = LineItem.count
    post :create, :line_item => {:product_id => @rails, :order_id => @rails_order, :quantity => 2, :total_price => 1111 }
    assert_equal old_count+1, LineItem.count    
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  def test_should_show_line_item
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_line_item
    put :update, :id => 1, :line_item => {:product_id => @rails, :order_id => @rails_order, :quantity => 2, :total_price => 1111 }
    assert_redirected_to line_item_path(assigns(:line_item))
  end
  
  def test_should_destroy_line_item
    old_count = LineItem.count
    delete :destroy, :id => 1
    assert_equal old_count-1, LineItem.count
    
    assert_redirected_to line_items_path
  end
end
