module OauthHelper
  def oauth_providers
    Rails.configuration.x.oauth_providers
  end
end
