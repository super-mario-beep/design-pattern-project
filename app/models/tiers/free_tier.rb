module Tiers
  class FreeTier < BaseTier
    def name
      "FREE"
    end

    def price
      0
    end

    def max_file_size
      2.megabytes
    end

    def daily_upload_limit
      5
    end

    def total_storage
      100.megabytes
    end
  end
end
