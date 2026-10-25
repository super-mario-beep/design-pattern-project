class ImageFilter < ImageComponent
  def initialize(image)
    @image = image
  end

  def pipeline
    @image.pipeline
  end

  def format
    @image.format
  end
end
