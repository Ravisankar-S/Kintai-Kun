module Admin
  class UsersController < ApplicationController
    before_action :require_admin!

    def index
      @users =
        User.order(:name)
    end

    def show
      @user =
        User.find(params[:id])

      @work_logs =
        @user.work_logs
             .order(clocked_in_at: :desc)
    end

    private

    def require_admin!
      unless current_user.role == "admin"
        redirect_to root_path,
                    alert: t("admin.access_denied")
      end
    end
  end
end