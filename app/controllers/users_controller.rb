class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)

      session[:locale] =
        @user.preferred_locale

      redirect_to edit_profile_path,
                  notice: t("users.profile_updated")

    else
      render :edit,
             status: :unprocessable_entity
    end
  end

  def destroy_avatar
    @user = current_user
    @user.avatar.purge_later if @user.avatar.attached?

    redirect_to edit_profile_path,
                notice: t("users.avatar_removed")
  end

  private

  def user_params
    params.require(:user).permit(
      :avatar,
      :name,
      :work_mode,
      :fixed_start_time,
      :fixed_end_time,
      :preferred_locale
    )
  end
end