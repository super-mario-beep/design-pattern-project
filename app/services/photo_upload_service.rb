class PhotoUploadService
  Result = Struct.new(:photo, :error)

  def initialize(user)
    @user = user
  end

  def upload(file, description: nil, hashtags: nil, options: {})
    options = normalize(options)

    error = upload_checks.check(@user, file)
    return reject(file, error) if error

    image = edited_image(file, options)
    processed = image.process

    error = StorageLimitCheck.new.check(@user, processed)
    return reject(file, error) if error

    photo = save(file, image.format, processed, description, hashtags)
    EventBus.publish("photo.uploaded", user: @user, subject: photo,
      details: { options: options.compact_blank, byte_size: photo.byte_size })
    Result.new(photo, nil)
  rescue ImageProcessing::Error, MiniMagick::Error
    reject(file, "This photo could not be processed")
  ensure
    processed&.close!
  end

  private
    def upload_checks
      checks = FileTypeCheck.new
      checks.set_next(FileSizeCheck.new).set_next(DailyLimitCheck.new).set_next(StorageLimitCheck.new)
      checks
    end

    def normalize(options)
      boolean = ActiveModel::Type::Boolean.new
      {
        resize_width: positive(options[:resize_width]),
        resize_height: positive(options[:resize_height]),
        sepia: boolean.cast(options[:sepia]) || false,
        blur: boolean.cast(options[:blur]) || false,
        format: Photo::FORMATS.include?(options[:format]) ? options[:format] : nil
      }
    end

    def positive(value)
      number = value.to_i
      number if number.positive?
    end

    def edited_image(file, options)
      image = OriginalImage.new(file)
      image = ResizeFilter.new(image, options[:resize_width], options[:resize_height]) if options[:resize_width] || options[:resize_height]
      image = SepiaFilter.new(image) if options[:sepia]
      image = BlurFilter.new(image) if options[:blur]
      image = FormatFilter.new(image, options[:format]) if options[:format]
      image
    end

    def save(file, format, processed, description, hashtags)
      key = "#{Time.current.strftime("%Y/%m")}/#{SecureRandom.uuid}.#{format}"
      StorageAdapter.current.write(key, processed)
      dimensions = MiniMagick::Image.new(processed.path)

      @user.photos.create!(
        description: description,
        hashtag_list: hashtags,
        storage_key: key,
        original_filename: file.original_filename,
        format: format,
        byte_size: processed.size,
        width: dimensions.width,
        height: dimensions.height
      )
    rescue StandardError
      StorageAdapter.current.delete(key) if key
      raise
    end

    def reject(file, error)
      EventBus.publish("photo.upload_rejected", user: @user, details: { filename: file.original_filename, error: error })
      Result.new(nil, error)
    end
end
