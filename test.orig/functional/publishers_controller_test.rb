require File.dirname(__FILE__) + '/../test_helper'
require 'publishers_controller'

# Re-raise errors caught by the controller.
class PublishersController; def rescue_action(e) raise e end; end

class PublishersControllerTest < Test::Unit::TestCase
  include AuthenticatedTestHelper  
  fixtures :publishers, :users

  def setup
    @controller = PublishersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as :quentin
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:publishers)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_publisher
    old_count = Publisher.count
    post :create, :publisher => { :name => 'Well Trained Mind',
                                  :url => 'http://www.welltrainedmind.org'}
    assert_equal old_count+1, Publisher.count
    
    assert_redirected_to publisher_path(assigns(:publisher))
  end

  def test_should_show_publisher
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_publisher
    put :update, :id => 1, :publisher => { :name => 'Arties Books' }
    assert_redirected_to publisher_path(assigns(:publisher))
  end
  
  def test_should_destroy_publisher
    old_count = Publisher.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Publisher.count
    
    assert_redirected_to publishers_path
  end
end
