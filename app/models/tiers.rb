module Tiers
  def self.for(name)
    case name.to_s.downcase
    when "free" then FreeTier.new
    when "pro" then ProTier.new
    when "gold" then GoldTier.new
    else raise ArgumentError, "Unknown tier: #{name}"
    end
  end
end
