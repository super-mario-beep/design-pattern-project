require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new shows all packages" do
    get new_registration_path

    assert_response :success
    assert_select "input[type=radio][name='user[tier_name]']", 3
  end

  test "create signs the user up, logs them in and logs the action" do
    assert_difference -> { User.count } => 1, -> { ActionLog.where(action: "user.registered").count } => 1 do
      post registration_path, params: { user: {
        name: "Mario", email_address: "mario@example.com",
        password: "secret123", password_confirmation: "secret123", tier_name: "pro"
      } }
    end

    user = User.find_by!(email_address: "mario@example.com")
    assert_equal "pro", user.tier_name
    assert user.user?
    assert_redirected_to root_path
    assert cookies[:session_id].present?
  end

  test "create cannot make an admin" do
    post registration_path, params: { user: {
      name: "Eve", email_address: "eve@example.com",
      password: "secret123", password_confirmation: "secret123", tier_name: "free", role: "admin"
    } }

    assert User.find_by!(email_address: "eve@example.com").user?
  end

  test "create with invalid data shows errors" do
    assert_no_difference -> { User.count } do
      post registration_path, params: { user: {
        name: "", email_address: "one@example.com",
        password: "short", password_confirmation: "other", tier_name: "free"
      } }
    end

    assert_response :unprocessable_content
    assert_select "li", /Name can't be blank/
    assert_select "li", /Email address has already been taken/
  end
end
