require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @general = users(:one)
    @admin = users(:two)
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should log in general user with correct credentials" do
    post login_url, params: { email: @general.email, password: "password" }
    assert_redirected_to user_path
  end

  test "should log in admin with correct credentials" do
    post login_url, params: { email: @admin.email, password: "password" }
    assert_redirected_to admin_users_path
  end

  test "should not log in with wrong password" do
    post login_url, params: { email: @general.email, password: "wrong-password" }
    assert_response :unprocessable_entity
  end

  test "should log out and redirect to login" do
    sign_in_as(@general)
    delete logout_url
    assert_redirected_to login_path
  end

  test "should redirect logout when not logged in" do
    delete logout_url
    assert_redirected_to login_path
  end
end
