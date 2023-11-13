module ApplicationHelper
  def bool_to_text(value)
    value ? t("simple_form.yes") : t("simple_form.no")
  end
end
