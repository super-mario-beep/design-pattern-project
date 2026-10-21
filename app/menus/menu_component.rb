class MenuComponent
  attr_reader :label

  def initialize(label)
    @label = label
  end

  def visible_to?(user)
    raise NotImplementedError
  end
end
