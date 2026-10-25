require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "guest is sent to log in" do
    get profile_path

    assert_redirected_to new_session_path
  end

  test "shows the current package and the other packages to choose" do
    sign_in_as(users(:one))

    get profile_path

    assert_response :success
    assert_select "p", /Current package: FREE/
    assert_select "input[type=radio][name=tier_name]", 2
  end
end
