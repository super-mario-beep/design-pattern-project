module Admin
  class ActionLogsController < BaseController
    PER_PAGE = 50

    def index
      logs = ActionLog.includes(:user, :subject).order(id: :desc)
      logs = params[:user_id] == "guest" ? logs.where(user_id: nil) : logs.where(user_id: params[:user_id]) if params[:user_id].present?
      logs = logs.where(action: params[:log_action]) if params[:log_action].present?

      @page = [ params[:page].to_i, 1 ].max
      page_logs = logs.offset((@page - 1) * PER_PAGE).limit(PER_PAGE + 1).to_a
      @next_page = page_logs.size > PER_PAGE
      @logs = page_logs.first(PER_PAGE)
      @total = logs.count
      @actions = ActionLog.distinct.order(:action).pluck(:action)
      @users = User.order(:name)
    end
  end
end
