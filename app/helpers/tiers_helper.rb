module TiersHelper
  def tier_summary(tier)
    uploads = tier.daily_upload_limit ? "#{tier.daily_upload_limit} uploads a day" : "unlimited uploads"

    [
      "#{number_to_human_size(tier.max_file_size)} per photo",
      uploads,
      "#{number_to_human_size(tier.total_storage)} storage",
      "#{tier.price} € / month"
    ].join(", ")
  end
end
