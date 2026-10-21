module Tiers
  class ProTier < BaseTier
    def name
      "PRO"
    end

    def price
      5
    end

    def max_file_size
      10.megabytes
    end

    def daily_upload_limit
      50
    end

    def total_storage
      2.gigabytes
    end
  end
end
