require 'test_helper'

class ShippingTermsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shipping_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shipping_term" do
    assert_difference('ShippingTerm.count') do
      post :create, :shipping_term => { }
    end

    assert_redirected_to shipping_term_path(assigns(:shipping_term))
  end

  test "should show shipping_term" do
    get :show, :id => shipping_terms(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => shipping_terms(:one).id
    assert_response :success
  end

  test "should update shipping_term" do
    put :update, :id => shipping_terms(:one).id, :shipping_term => { }
    assert_redirected_to shipping_term_path(assigns(:shipping_term))
  end

  test "should destroy shipping_term" do
    assert_difference('ShippingTerm.count', -1) do
      delete :destroy, :id => shipping_terms(:one).id
    end

    assert_redirected_to shipping_terms_path
  end
end
