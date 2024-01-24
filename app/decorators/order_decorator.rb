class OrderDecorator < ApplicationDecorator
  delegate_all

  def shipping_step
    if pending?
      I18n.t("activerecord.attributes.order.shipping_status_list.processing")
    elsif processing?
      I18n.t("activerecord.attributes.order.shipping_status_list.shipped")
    elsif shipped?
      I18n.t("activerecord.attributes.order.shipping_status_list.completed")
    end
  end
end
