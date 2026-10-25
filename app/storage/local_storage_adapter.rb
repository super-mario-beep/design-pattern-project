class LocalStorageAdapter < StorageAdapter
  def initialize(root)
    @root = Pathname(root).expand_path
  end

  def write(key, io)
    path = path_for(key)
    FileUtils.mkdir_p(path.dirname)
    io.rewind if io.respond_to?(:rewind)
    IO.copy_stream(io, path)
  end

  def read(key)
    File.binread(path_for(key))
  rescue Errno::ENOENT
    raise FileNotFound, key
  end

  def delete(key)
    FileUtils.rm_f(path_for(key))
  end

  def exists?(key)
    path_for(key).file?
  end

  private
    def path_for(key)
      path = @root.join(key).expand_path
      raise ArgumentError, "Invalid storage key: #{key}" unless path.to_s.start_with?("#{@root}/")

      path
    end
end
