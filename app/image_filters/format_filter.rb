class FormatFilter < ImageFilter
  def initialize(image, format)
    raise ArgumentError, "Unknown format: #{format}" unless Photo::FORMATS.include?(format)

    super(image)
    @format = format
  end

  def pipeline
    super.convert(@format)
  end

  def format
    @format
  end
end
