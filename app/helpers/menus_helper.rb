module MenusHelper
  # Add a MenuItem here when its page is built
  def main_menu
    Menu.new("Main menu")
      .add(MenuItem.new("Home", root_path))
      .add(MenuItem.new("Log in", new_session_path, audience: :guests))
  end
end
