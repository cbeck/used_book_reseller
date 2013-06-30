require 'test_helper'

class MetroAreasControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metro_areas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metro_area" do
    assert_difference('MetroArea.count') do
      post :create, :metro_area => { }
    end

    assert_redirected_to metro_area_path(assigns(:metro_area))
  end

  test "should show metro_area" do
    get :show, :id => metro_areas(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => metro_areas(:one).id
    assert_response :success
  end

  test "should update metro_area" do
    put :update, :id => metro_areas(:one).id, :metro_area => { }
    assert_redirected_to metro_area_path(assigns(:metro_area))
  end

  test "should destroy metro_area" do
    assert_difference('MetroArea.count', -1) do
      delete :destroy, :id => metro_areas(:one).id
    end

    assert_redirected_to metro_areas_path
  end
end
