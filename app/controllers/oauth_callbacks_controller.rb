class OauthCallbacksController < ApplicationController
  allow_unauthenticated_access

  def create
    login = OauthLogin.for(request.env["omniauth.auth"])
    label = provider_label(login.provider)

    if login.email.blank?
      redirect_to new_session_path, alert: "Your #{label} account has no verified email address."
    elsif (user = login.find_user)
      start_new_session_for user
      EventBus.publish("user.logged_in", user: user, details: { via: label })
      redirect_to after_authentication_url, notice: "Logged in with #{label}."
    else
      session[:oauth_profile] = login.profile
      redirect_to new_oauth_registration_path
    end
  end

  def failure
    redirect_to new_session_path, alert: "Login was cancelled or failed. Please try again."
  end

  private
    def provider_label(provider)
      Rails.configuration.x.oauth_providers.fetch(provider.to_sym, provider.to_s.titleize)
    end
end
