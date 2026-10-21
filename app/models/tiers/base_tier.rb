module Tiers
  class BaseTier
    def name
      raise NotImplementedError
    end

    def price
      raise NotImplementedError
    end

    def max_file_size
      raise NotImplementedError
    end

    def daily_upload_limit
      raise NotImplementedError
    end

    def total_storage
      raise NotImplementedError
    end

    def file_size_allowed?(size)
      size <= max_file_size
    end

    def can_upload_today?(uploads_today)
      uploads_today < daily_upload_limit
    end

    def fits_in_storage?(used, new_size)
      used + new_size <= total_storage
    end
  end
end
