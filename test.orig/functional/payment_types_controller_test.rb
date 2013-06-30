require File.dirname(__FILE__) + '/../test_helper'
require 'payment_types_controller'

# Re-raise errors caught by the controller.
class PaymentTypesController; def rescue_action(e) raise e end; end

class PaymentTypesControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper  
  fixtures :payment_types, :users, :roles_users, :roles

  def setup
    @controller = PaymentTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:payment_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_payment_type
    old_count = PaymentType.count
    post :create, :payment_type => {:name => 'Visa' }
    assert_equal old_count+1, PaymentType.count
    
    assert_redirected_to payment_type_path(assigns(:payment_type))
  end

  def test_should_show_payment_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_payment_type
    put :update, :id => 1, :payment_type => { :name => 'American Express' }
    assert_redirected_to payment_type_path(assigns(:payment_type))
  end
  
  def test_should_destroy_payment_type
    old_count = PaymentType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, PaymentType.count
    
    assert_redirected_to payment_types_path
  end
end
