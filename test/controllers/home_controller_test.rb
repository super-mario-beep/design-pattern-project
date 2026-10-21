require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "guest sees log in link" do
    get root_path

    assert_response :success
    assert_select "a", "Log in"
  end

  test "logged in user sees log out button" do
    sign_in_as(users(:one))

    get root_path

    assert_response :success
    assert_select "button", "Log out"
  end
end
