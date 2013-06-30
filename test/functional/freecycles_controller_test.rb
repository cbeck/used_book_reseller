require 'test_helper'

class FreecyclesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:freecycles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create freecycle" do
    assert_difference('Freecycle.count') do
      post :create, :freecycle => { }
    end

    assert_redirected_to freecycle_path(assigns(:freecycle))
  end

  test "should show freecycle" do
    get :show, :id => freecycles(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => freecycles(:one).id
    assert_response :success
  end

  test "should update freecycle" do
    put :update, :id => freecycles(:one).id, :freecycle => { }
    assert_redirected_to freecycle_path(assigns(:freecycle))
  end

  test "should destroy freecycle" do
    assert_difference('Freecycle.count', -1) do
      delete :destroy, :id => freecycles(:one).id
    end

    assert_redirected_to freecycles_path
  end
end
