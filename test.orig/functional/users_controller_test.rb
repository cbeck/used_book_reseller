require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users, :account_types

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @account_type = account_types(:free)
    @payment_types = PaymentType.find(:all, :order => "name" ).map {|p| [p.name, p.id] }
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_should_get_new
    get :new, {:account_type_id => @account_type}
    assert_response :success
  end
  
  def test_should_create_user
    old_count = User.count
    post :create, 
        :user => {:login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire'  },
        :account_type => {:id => @account_type}
    assert_equal old_count+1, User.count
    
    assert_redirected_to :controller => "site", :action => :index
  end

  def test_should_show_user
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_user
    put :update, :id => 1, :user => { }
    assert_redirected_to user_path(assigns(:user))
  end
  
  def test_should_destroy_user
    old_count = User.count
    delete :destroy, :id => 1
    assert_equal old_count-1, User.count
    
    #assert_redirected_to users_path
  end

  protected
    def create_user(options = {})
      User.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
