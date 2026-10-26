class ImageEditor
  attr_reader :options

  def initialize(options = {})
    @options = normalize(options)
  end

  def edit(file)
    image = OriginalImage.new(file)
    image = ResizeFilter.new(image, options[:resize_width], options[:resize_height]) if options[:resize_width] || options[:resize_height]
    image = SepiaFilter.new(image) if options[:sepia]
    image = BlurFilter.new(image) if options[:blur]
    image = FormatFilter.new(image, options[:format]) if options[:format]
    image
  end

  def changes?
    options.values.any?
  end

  private
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
end
