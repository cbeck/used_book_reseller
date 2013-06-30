require 'test_helper'

class MediaMailsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:media_mails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create media_mail" do
    assert_difference('MediaMail.count') do
      post :create, :media_mail => { }
    end

    assert_redirected_to media_mail_path(assigns(:media_mail))
  end

  test "should show media_mail" do
    get :show, :id => media_mails(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => media_mails(:one).id
    assert_response :success
  end

  test "should update media_mail" do
    put :update, :id => media_mails(:one).id, :media_mail => { }
    assert_redirected_to media_mail_path(assigns(:media_mail))
  end

  test "should destroy media_mail" do
    assert_difference('MediaMail.count', -1) do
      delete :destroy, :id => media_mails(:one).id
    end

    assert_redirected_to media_mails_path
  end
end
