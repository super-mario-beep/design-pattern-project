class BlurFilter < ImageFilter
  def pipeline
    super.blur("0x4")
  end
end
