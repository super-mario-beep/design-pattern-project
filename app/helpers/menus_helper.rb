module MenusHelper
  # Add a MenuItem here when its page is built
  def main_menu
    Menu.new("Main menu")
      .add(MenuItem.new("Home", root_path))
      .add(MenuItem.new("Search", search_path))
      .add(MenuItem.new("Upload", new_photo_path, audience: :users))
      .add(MenuItem.new("Profile", profile_path, audience: :users))
      .add(MenuItem.new("Log in", new_session_path, audience: :guests))
      .add(MenuItem.new("Sign up", new_registration_path, audience: :guests))
      .add(Menu.new("Admin")
        .add(MenuItem.new("Users", admin_users_path, audience: :admins))
        .add(MenuItem.new("Actions", admin_action_logs_path, audience: :admins))
        .add(MenuItem.new("Statistics", admin_statistics_path, audience: :admins)))
  end
end
