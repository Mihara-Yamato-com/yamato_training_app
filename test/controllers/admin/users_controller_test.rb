require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:two)
    @general = users(:one)
  end

  test "should get index when logged in as admin" do
    sign_in_as(@admin)
    get admin_users_url
    assert_response :success
  end

  test "should get edit when logged in as admin" do
    sign_in_as(@admin)
    get edit_admin_user_url(@general)
    assert_response :success
  end

  test "should redirect index when not logged in" do
    get admin_users_url
    assert_redirected_to user_path
  end

  test "should redirect index when logged in as general user" do
    sign_in_as(@general)
    get admin_users_url
    assert_redirected_to user_path
  end
end
