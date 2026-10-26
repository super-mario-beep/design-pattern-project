class GoogleLogin < OauthLogin
  def email
    @auth.info.email
  end

  def name
    @auth.info.name.presence || email.to_s.split("@").first
  end

  def email_verified?
    ActiveModel::Type::Boolean.new.cast(@auth.dig("extra", "raw_info", "email_verified")) || false
  end
end
