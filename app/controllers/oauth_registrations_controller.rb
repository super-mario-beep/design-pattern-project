class OauthRegistrationsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_profile

  def new
    @user = User.new(name: @profile["name"], email_address: @profile["email"], tier_name: "free")
  end

  def create
    @user = OauthLogin.register(@profile, name: params.dig(:user, :name), tier_name: params.dig(:user, :tier_name))

    if @user.persisted?
      session.delete(:oauth_profile)
      start_new_session_for @user
      EventBus.publish("user.registered", user: @user, subject: @user, details: { tier: @user.tier_name, via: @provider_label })
      redirect_to root_path, notice: "Welcome, #{@user.name}!"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def set_profile
      @profile = session[:oauth_profile]
      return redirect_to(new_registration_path) if @profile.blank?

      @provider_label = Rails.configuration.x.oauth_providers.fetch(@profile["provider"].to_sym, @profile["provider"].titleize)
    end
end
