class StorageAdapter
  class FileNotFound < StandardError; end

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
