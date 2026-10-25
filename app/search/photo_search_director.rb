class PhotoSearchDirector
  def initialize(builder = PhotoSearchBuilder.new)
    @builder = builder
  end

  def construct(params)
    hashtags = params[:hashtags].to_s.split(/[\s,]+/).map { |name| Hashtag.normalize_value_for(:name, name) }.compact_blank
    @builder.with_hashtags(hashtags) if hashtags.any?

    min_size = kilobytes(params[:min_size])
    max_size = kilobytes(params[:max_size])
    @builder.with_size(min_size, max_size) if min_size || max_size

    from = time(params[:uploaded_from])
    to = time(params[:uploaded_to], end_of_day: true)
    @builder.uploaded_between(from, to) if from || to

    @builder.by_author(params[:author].strip) if params[:author].present?

    @builder.build
  end

  private
    def kilobytes(value)
      number = value.to_f
      (number * 1.kilobyte).to_i if number.positive?
    end

    def time(value, end_of_day: false)
      return if value.blank?

      parsed = Time.zone.parse(value.to_s)
      date_only = value.to_s.match?(/\A\d{4}-\d{2}-\d{2}\z/)
      end_of_day && date_only ? parsed&.end_of_day : parsed
    rescue ArgumentError
      nil
    end
end
