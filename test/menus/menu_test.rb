require "test_helper"

class MenuTest < ActiveSupport::TestCase
  setup do
    @admin_menu = Menu.new("Admin")
      .add(MenuItem.new("Users", "/admin/users", audience: :admins))
    @main_menu = Menu.new("Main menu")
      .add(MenuItem.new("Home", "/"))
      .add(MenuItem.new("Upload", "/photos/new", audience: :users))
      .add(MenuItem.new("Log in", "/session/new", audience: :guests))
      .add(@admin_menu)
  end

  test "guest sees public and guest items" do
    assert_equal [ "Home", "Log in" ], labels(nil)
  end

  test "user sees user items but not the admin submenu" do
    assert_equal [ "Home", "Upload" ], labels(User.new(role: :user))
  end

  test "admin sees the admin submenu" do
    assert_equal [ "Home", "Upload", "Admin" ], labels(User.new(role: :admin))
  end

  test "a menu is visible only if one of its children is" do
    assert_not @admin_menu.visible_to?(User.new(role: :user))
    assert @admin_menu.visible_to?(User.new(role: :admin))
  end

  test "unknown audience raises" do
    assert_raises(ArgumentError) { MenuItem.new("X", "/x", audience: :admin) }
  end

  private
    def labels(user)
      @main_menu.visible_children(user).map(&:label)
    end
end
