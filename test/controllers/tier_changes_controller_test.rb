require "test_helper"

class TierChangesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as(@user)
  end

  test "requests a change for tomorrow and logs it" do
    assert_difference -> { ActionLog.where(action: "tier.change_requested", user: @user).count }, 1 do
      post tier_change_path, params: { tier_name: "gold" }
    end

    assert_redirected_to profile_path
    assert_equal "gold", @user.reload.next_tier_name
    assert_equal Date.tomorrow, @user.next_tier_starts_on
  end

  test "second change on the same day is refused" do
    post tier_change_path, params: { tier_name: "gold" }

    assert_no_difference -> { ActionLog.count } do
      post tier_change_path, params: { tier_name: "pro" }
    end

    assert_equal "You can change your package only once a day", flash[:alert]
    assert_equal "gold", @user.reload.next_tier_name
  end
end
