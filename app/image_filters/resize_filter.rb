class ResizeFilter < ImageFilter
  def initialize(image, width, height)
    super(image)
    @width = width
    @height = height
  end

  def pipeline
    super.resize_to_limit(@width, @height)
  end
end
