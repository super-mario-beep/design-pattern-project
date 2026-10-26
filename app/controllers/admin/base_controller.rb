module Admin
  class BaseController < ApplicationController
    before_action :require_admin

    private
      def require_admin
        redirect_to root_path, alert: "Only administrators can open that page." unless Current.user&.admin?
      end
  end
end
