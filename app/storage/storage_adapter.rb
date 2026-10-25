class StorageAdapter
  class FileNotFound < StandardError; end

  def self.current
    @current ||=
      case Rails.configuration.x.photo_storage
      when "local" then LocalStorageAdapter.new(Rails.root.join("storage", "photos", Rails.env))
      when "s3" then S3StorageAdapter.new(bucket: ENV.fetch("S3_BUCKET"))
      else raise ArgumentError, "Unknown photo storage: #{Rails.configuration.x.photo_storage}"
      end
  end

  def write(key, io)
    raise NotImplementedError
  end

  def read(key)
    raise NotImplementedError
  end

  def delete(key)
    raise NotImplementedError
  end

  def exists?(key)
    raise NotImplementedError
  end
end
