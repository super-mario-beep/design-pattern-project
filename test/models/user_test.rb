require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup { @user = users(:one) }

  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "tier returns the strategy for the tier name" do
    assert_instance_of Tiers::FreeTier, @user.tier
  end

  test "rejects an unknown tier name" do
    @user.tier_name = "silver"
    assert_not @user.valid?
  end

  test "tier change starts tomorrow" do
    assert @user.request_tier_change("pro")

    assert_equal "free", @user.current_tier_name
    assert_equal "pro", @user.pending_tier_name

    travel_to Date.tomorrow do
      assert_equal "pro", @user.current_tier_name
      assert_instance_of Tiers::ProTier, @user.tier
      assert_nil @user.pending_tier_name
    end
  end

  test "tier can change only once a day" do
    assert @user.request_tier_change("pro")
    assert_not @user.request_tier_change("gold")
    assert_includes @user.errors[:base], "You can change your package only once a day"

    travel_to Date.tomorrow do
      assert @user.request_tier_change("gold")
      assert_equal "pro", @user.reload.tier_name
      assert_equal "gold", @user.pending_tier_name
    end
  end

  test "tier change rejects the current and unknown tiers" do
    assert_not @user.request_tier_change("free")
    assert_not @user.request_tier_change("silver")
    assert_not @user.request_tier_change(nil)
    assert_nil @user.reload.tier_changed_on
  end
end
