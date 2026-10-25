class FileSizeCheck < UploadCheck
  private
    def problem(user, file)
      tier = user.tier
      return if tier.file_size_allowed?(file.size)

      "This photo is #{human_size(file.size)}, your #{tier.name} package allows up to #{human_size(tier.max_file_size)} per photo"
    end
end
