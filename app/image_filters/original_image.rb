class OriginalImage < ImageComponent
  FORMATS = { "image/jpeg" => "jpg", "image/png" => "png", "image/bmp" => "bmp" }.freeze

  def initialize(file)
    @file = file
  end

  def pipeline
    ImageProcessing::MiniMagick.source(@file)
  end

  def format
    FORMATS.fetch(Marcel::MimeType.for(Pathname(@file.path)))
  end
end
