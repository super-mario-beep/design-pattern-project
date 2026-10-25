class SepiaFilter < ImageFilter
  def pipeline
    super.sepia_tone("80%")
  end
end
