oauth_providers = {
  google_oauth2: { label: "Google", env: "GOOGLE", credentials: :google, options: { scope: "email,profile", prompt: "select_account" } }
}.filter_map do |key, provider|
  client_id = ENV["#{provider[:env]}_CLIENT_ID"].presence || Rails.application.credentials.dig(provider[:credentials], :client_id)
  client_secret = ENV["#{provider[:env]}_CLIENT_SECRET"].presence || Rails.application.credentials.dig(provider[:credentials], :client_secret)
  [ key, provider.merge(client_id: client_id, client_secret: client_secret) ] if client_id.present? && client_secret.present?
end.to_h

Rails.application.config.x.oauth_providers = oauth_providers.transform_values { |provider| provider[:label] }

Rails.application.config.middleware.use OmniAuth::Builder do
  oauth_providers.each do |key, provider|
    provider key, provider[:client_id], provider[:client_secret], provider[:options]
  end
end

OmniAuth.config.failure_raise_out_environments = []
