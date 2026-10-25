class StorageLimitCheck < UploadCheck
  private
    def problem(user, file)
      tier = user.tier
      used = user.storage_used
      return if tier.fits_in_storage?(used, file.size)

      "Not enough storage left: #{human_size(used)} of #{human_size(tier.total_storage)} used on the #{tier.name} package"
    end
end
