module LocaleHelper
  extend ActiveSupport::Concern

  included do
    around_action :with_locale
  end

  def change_locale
    skip_policy_scope
    skip_authorization

    session[:locale] = current_language == :fr ? :en : :fr

    redirect_back(fallback_location: root_path)
  end

  private

  def with_locale(&action)
    I18n.with_locale(current_language, &action)
  end

  def current_language
    (session[:locale].presence || browser_language || I18n.default_locale).to_sym
  end

  def browser_language
    header = request.env["HTTP_ACCEPT_LANGUAGE"].try(:scan, /^[a-z]{2}/)&.first&.to_sym

    return if header.blank? || I18n.available_locales.exclude?(header)

    header
  end
end
