class OauthLogin
  def self.for(auth)
    case auth.provider
    when "google_oauth2" then GoogleLogin.new(auth)
    else raise ArgumentError, "Unknown provider: #{auth.provider}"
    end
  end

  def self.register(profile, name:, tier_name:)
    user = User.new(name: name, email_address: profile["email"], tier_name: tier_name, password: SecureRandom.base58(24))
    User.transaction do
      user.save && user.identities.create!(provider: profile["provider"], uid: profile["uid"], email: profile["email"])
    end
    user
  end

  def initialize(auth)
    @auth = auth
  end

  def find_user
    identity = Identity.find_by(provider: provider, uid: uid)
    return identity.user if identity
    return unless email.present? && email_verified?

    user = User.find_by(email_address: email.downcase)
    user&.identities&.create!(provider: provider, uid: uid, email: email)
    user
  end

  def profile
    { "provider" => provider, "uid" => uid, "email" => email, "name" => name }
  end

  def provider
    @auth.provider
  end

  def uid
    @auth.uid.to_s
  end

  def email
    raise NotImplementedError
  end

  def name
    raise NotImplementedError
  end

  def email_verified?
    true
  end
end
