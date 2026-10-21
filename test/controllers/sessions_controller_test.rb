require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = User.take }

  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials" do
    assert_difference -> { ActionLog.where(action: "user.logged_in", user: @user).count }, 1 do
      post session_path, params: { email_address: @user.email_address, password: "password" }
    end

    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    assert_no_difference -> { ActionLog.count } do
      post session_path, params: { email_address: @user.email_address, password: "wrong" }
    end

    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(@user)

    assert_difference -> { ActionLog.where(action: "user.logged_out", user: @user).count }, 1 do
      delete session_path
    end

    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
