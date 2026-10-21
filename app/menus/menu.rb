class Menu < MenuComponent
  attr_reader :children

  def initialize(label)
    super
    @children = []
  end

  def add(component)
    children << component
    self
  end

  def visible_to?(user)
    children.any? { |child| child.visible_to?(user) }
  end

  def visible_children(user)
    children.select { |child| child.visible_to?(user) }
  end

  def to_partial_path
    "menus/menu"
  end
end
