module Tiers
  class GoldTier < BaseTier
    def name
      "GOLD"
    end

    def price
      15
    end

    def max_file_size
      50.megabytes
    end

    def daily_upload_limit
      nil
    end

    def total_storage
      20.gigabytes
    end

    def can_upload_today?(_uploads_today)
      true
    end
  end
end
