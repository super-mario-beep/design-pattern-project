class DailyLimitCheck < UploadCheck
  private
    def problem(user, file)
      tier = user.tier
      return if tier.can_upload_today?(user.uploads_today)

      "You reached your daily limit of #{tier.daily_upload_limit} uploads on the #{tier.name} package"
    end
end
