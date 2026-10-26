module Admin
  class UsersController < BaseController
    before_action :set_user, only: %i[ edit update ]

    def index
      @users = User.order(:name)
      @photo_stats = Photo.group(:user_id)
        .pluck(:user_id, Arel.sql("COUNT(*)"), Arel.sql("COALESCE(SUM(byte_size), 0)"))
        .to_h { |user_id, count, bytes| [ user_id, { count: count, bytes: bytes } ] }
    end

    def edit
      load_details
    end

    def update
      attributes = params.expect(user: [ :name, :email_address, :role, :tier_name ])
      attributes.delete(:role) if @user == Current.user

      if attributes[:tier_name].present? && attributes[:tier_name] != @user.current_tier_name
        @user.assign_attributes(next_tier_name: nil, next_tier_starts_on: nil)
      end

      if @user.update(attributes)
        changes = @user.saved_changes.except("updated_at").transform_values(&:last)
        EventBus.publish("admin.user_updated", user: Current.user, subject: @user, details: changes) if changes.any?
        redirect_to edit_admin_user_path(@user), notice: "User updated."
      else
        load_details
        render :edit, status: :unprocessable_content
      end
    end

    private
      def set_user
        @user = User.find(params[:id])
      end

      def load_details
        @photos = @user.photos.includes(:user, :hashtags).latest
        @logs = ActionLog.includes(:user, :subject).where(user: @user).order(id: :desc).limit(20)
      end
  end
end
