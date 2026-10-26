module Admin
  class StatisticsController < BaseController
    def show
      today = Time.current.all_day

      @user_count = User.count
      @photo_count = Photo.count
      @storage_total = Photo.sum(:byte_size)
      @uploads_today = ActionLog.where(action: "photo.uploaded", created_at: today).count
      @downloads_total = ActionLog.where(action: "photo.downloaded").count
      @logins_today = ActionLog.where(action: "user.logged_in", created_at: today).count

      tier_counts = User.all.map(&:current_tier_name).tally
      @users_per_tier = Tiers::NAMES.map { |name| [ name.upcase, tier_counts.fetch(name, 0) ] }

      days = (6.days.ago.to_date..Date.current).to_a
      upload_days = ActionLog.where(action: "photo.uploaded", created_at: days.first.in_time_zone..)
        .pluck(:created_at).map { |time| time.in_time_zone.to_date }.tally
      @uploads_by_day = days.map { |day| [ day, upload_days.fetch(day, 0) ] }

      @top_uploaders = User.joins(:photos).group("users.id").order(Arel.sql("COUNT(photos.id) DESC")).limit(5)
        .pluck(:id, :name, Arel.sql("COUNT(photos.id)"), Arel.sql("SUM(photos.byte_size)"))

      @action_counts = ActionLog.group(:action).count.sort_by { |_, count| -count }
    end
  end
end
