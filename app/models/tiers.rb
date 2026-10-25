module Tiers
  NAMES = %w[ free pro gold ].freeze

  def self.for(name)
    case name.to_s.downcase
    when "free" then FreeTier.new
    when "pro" then ProTier.new
    when "gold" then GoldTier.new
    else raise ArgumentError, "Unknown tier: #{name}"
    end
  end

  def self.all
    NAMES.map { |name| self.for(name) }
  end
end
