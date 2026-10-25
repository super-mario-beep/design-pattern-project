class ImageComponent
  def pipeline
    raise NotImplementedError
  end

  def format
    raise NotImplementedError
  end

  def process
    pipeline.call
  end
end
