require File.dirname(__FILE__) + '/../test_helper'
require 'account_types_controller'

# Re-raise errors caught by the controller.
class AccountTypesController; def rescue_action(e) raise e end; end

class AccountTypesControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper  
  fixtures :account_types, :users, :roles_users, :roles

  def setup
    @controller = AccountTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:account_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_account_type
    old_count = AccountType.count
    post :create, :account_type => {
      :name => "New Free Account",
      :description => "How can you beat it?",
      :price => 0,
      :commission => 0,
      :flat_fee => 0 }
    assert_equal old_count+1, AccountType.count
    
    assert_redirected_to account_type_path(assigns(:account_type))
  end

  def test_should_show_account_type
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_account_type
    put :update, :id => 1, :account_type => {:name => "Updated name" }
    assert_redirected_to account_type_path(assigns(:account_type))
  end
  
  def test_should_destroy_account_type
    old_count = AccountType.count
    delete :destroy, :id => 1
    assert_equal old_count-1, AccountType.count
    
    assert_redirected_to account_types_path
  end
end
