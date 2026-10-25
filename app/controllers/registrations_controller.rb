class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_path, alert: "Try again later." }

  def new
    @user = User.new(tier_name: "free")
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      start_new_session_for @user
      EventBus.publish("user.registered", user: @user, subject: @user, details: { tier: @user.tier_name })
      redirect_to root_path, notice: "Welcome, #{@user.name}!"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def registration_params
      params.expect(user: [ :name, :email_address, :password, :password_confirmation, :tier_name ])
    end
end
