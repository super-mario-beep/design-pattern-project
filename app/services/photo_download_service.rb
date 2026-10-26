class PhotoDownloadService
  Result = Struct.new(:data, :filename, :content_type)

  def initialize(user, photo)
    @user = user
    @photo = photo
  end

  def original
    data = StorageAdapter.current.read(@photo.storage_key)
    EventBus.publish("photo.downloaded", user: @user, subject: @photo, details: { version: "original" })
    Result.new(data, filename(@photo.format), content_type(@photo.format))
  end

  def edited(options)
    editor = ImageEditor.new(options)
    return original unless editor.changes?

    Tempfile.create([ "photo", ".#{@photo.format}" ], binmode: true) do |source|
      source.write(StorageAdapter.current.read(@photo.storage_key))
      source.flush
      image = editor.edit(source)
      processed = image.process
      EventBus.publish("photo.downloaded", user: @user, subject: @photo,
        details: { version: "edited", options: editor.options.compact_blank })
      Result.new(File.binread(processed.path), filename(image.format, "edited"), content_type(image.format))
    ensure
      processed&.close!
    end
  end

  private
    def filename(format, suffix = nil)
      base = File.basename(@photo.original_filename.to_s, ".*").parameterize.presence || "photo-#{@photo.id}"
      [ base, suffix ].compact.join("-") + ".#{format}"
    end

    def content_type(format)
      Marcel::MimeType.for(extension: format)
    end
end
