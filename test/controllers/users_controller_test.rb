require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should get show when logged in" do
    sign_in_as(@user)
    get user_url
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in_as(@user)
    get edit_user_url
    assert_response :success
  end

  test "should redirect show when not logged in" do
    get user_url
    assert_redirected_to login_path
  end

  test "should redirect edit when not logged in" do
    get edit_user_url
    assert_redirected_to login_path
  end
end
