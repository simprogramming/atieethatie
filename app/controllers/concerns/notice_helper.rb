module NoticeHelper
  # :nocov:
  def create_successful_notice(model: nil, params: {})
    translated_notice(model, :created, params)
  end

  def update_successful_notice(model: nil, params: {})
    translated_notice(model, :updated, params)
  end

  def destroy_successful_notice(model: nil, params: {})
    translated_notice(model, :destroyed, params)
  end

  def archive_successful_notice(model: nil, params: {})
    translated_notice(model, :archived, params)
  end

  def restore_successful_notice(model: nil, params: {})
    translated_notice(model, :restored, params)
  end

  def unknown_error_notice
    t("errors.messages.unknown")
  end

  private

  def translated_notice(model, action, params)
    model ||= controller_name.classify
    params[:default] = t("activerecord.notices.default.#{action}_successfully", model: translated_model_name(model))
    t("activerecord.notices.#{model.to_s.underscore}.#{action}_successfully", **params)
  end

  def translated_model_name(model)
    namespace = self.class.module_parent == Object ? "" : "#{self.class.module_parent.name}::"
    namespace.sub!("Admin::", "")
    namespace.sub!("Web::", "")

    "#{namespace}#{model}".constantize.model_name.human
  end
  # :nocov:
end
