class SearchesController < ApplicationController
  FIELDS = %i[ hashtags author min_size max_size uploaded_from uploaded_to ].freeze

  allow_unauthenticated_access

  def show
    @query = params.slice(*FIELDS).permit(*FIELDS)
    return if @query.values.none?(&:present?)

    @photos = PhotoSearchDirector.new.construct(@query).limit(50)
    EventBus.publish("photo.searched", user: current_user, details: @query.to_h.compact_blank)
  end
end
