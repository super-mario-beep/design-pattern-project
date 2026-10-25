class TierChangesController < ApplicationController
  def create
    user = Current.user
    previous_tier_name = user.current_tier_name

    if user.request_tier_change(params[:tier_name])
      EventBus.publish("tier.change_requested", user: user, subject: user,
        details: { from: previous_tier_name, to: user.next_tier_name, starts_on: user.next_tier_starts_on })
      redirect_to profile_path, notice: "Your package changes to #{user.next_tier_name.upcase} on #{l user.next_tier_starts_on}."
    else
      redirect_to profile_path, alert: user.errors.full_messages.to_sentence
    end
  end
end
