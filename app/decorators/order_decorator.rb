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

  def shipping_fee
    if order_items.sum(&:quantity) == 1
      8
    else
      ((order_items.sum(&:quantity) - 1) * 3) + 8
    end
  end
end
