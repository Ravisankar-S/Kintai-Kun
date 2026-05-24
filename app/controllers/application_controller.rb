class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :set_timezone
  before_action :configure_permitted_parameters,
                if: :devise_controller?
  before_action :authenticate_user!

  def set_locale_action
    locale = params[:locale].to_s

    if I18n.available_locales.map(&:to_s).include?(locale)
      normalized_locale = locale.to_sym
      session[:locale] = normalized_locale
      I18n.locale = normalized_locale
      current_user&.update(preferred_locale: normalized_locale)
    end

    redirect_back fallback_location: dashboard_path
  end

  def set_timezone_action
    timezone = params[:timezone].to_s
    allowed_zones = ['Asia/Kolkata', 'Asia/Tokyo']
    
    if allowed_zones.include?(timezone)
      session[:timezone] = timezone
    end
    
    redirect_back fallback_location: dashboard_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:name]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [
        :avatar,
        :name,
        :work_mode,
        :fixed_start_time,
        :fixed_end_time,
        :preferred_locale
      ]
    )
  end

  private
  
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  def set_locale
    available_locales = I18n.available_locales.map(&:to_s)
    session_locale = session[:locale].to_s
    user_locale = current_user&.preferred_locale.to_s

    I18n.locale =
      if available_locales.include?(session_locale)
        session_locale.to_sym
      elsif available_locales.include?(user_locale)
        user_locale.to_sym
      else
        :en
      end
  end

  def set_timezone
    # Default to IST if not set
    Time.zone = session[:timezone] || 'Asia/Kolkata'
  end

end