require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "guest sees log in in the menu" do
    get root_path

    assert_response :success
    assert_select "nav a", "Log in"
    assert_select "nav button", text: "Log out", count: 0
  end

  test "logged in user sees log out instead of log in" do
    sign_in_as(users(:one))

    get root_path

    assert_response :success
    assert_select "nav a", text: "Log in", count: 0
    assert_select "nav button", "Log out"
  end
end
