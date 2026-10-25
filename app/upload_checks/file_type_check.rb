class FileTypeCheck < UploadCheck
  ALLOWED_TYPES = %w[ image/jpeg image/png image/bmp ].freeze

  private
    def problem(user, file)
      type = Marcel::MimeType.for(file)
      file.rewind
      "Only JPG, PNG and BMP photos are allowed" unless ALLOWED_TYPES.include?(type)
    end
end
