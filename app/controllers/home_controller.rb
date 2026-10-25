class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @photos = Photo.includes(:user, :hashtags).latest.limit(10)
  end
end
