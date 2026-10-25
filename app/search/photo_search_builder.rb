class PhotoSearchBuilder
  def initialize
    @scope = Photo.all
  end

  def with_hashtags(names)
    names.each do |name|
      @scope = @scope.where(id: PhotoHashtag.joins(:hashtag).where(hashtags: { name: name }).select(:photo_id))
    end
    self
  end

  def with_size(min_bytes, max_bytes)
    @scope = @scope.where(byte_size: min_bytes..max_bytes)
    self
  end

  def uploaded_between(from, to)
    @scope = @scope.where(created_at: from..to)
    self
  end

  def by_author(name)
    @scope = @scope.joins(:user).where("users.name LIKE ?", "%#{Photo.sanitize_sql_like(name)}%")
    self
  end

  def build
    @scope.includes(:user, :hashtags).latest
  end
end
