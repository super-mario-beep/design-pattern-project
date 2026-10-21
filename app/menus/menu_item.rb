class MenuItem < MenuComponent
  AUDIENCES = %i[ everyone guests users admins ].freeze

  attr_reader :path, :audience

  def initialize(label, path, audience: :everyone)
    raise ArgumentError, "Unknown audience: #{audience}" unless AUDIENCES.include?(audience)

    super(label)
    @path = path
    @audience = audience
  end

  def visible_to?(user)
    case audience
    when :everyone then true
    when :guests then user.nil?
    when :users then user.present?
    when :admins then user.present? && user.admin?
    end
  end

  def to_partial_path
    "menus/menu_item"
  end
end
