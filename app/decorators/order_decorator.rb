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
    return 0 if object.free_shipping?

    total_quantity = order_items.sum(&:quantity)
    if total_quantity > 1
      ((total_quantity - 1) * 3) + 10
    else
      10
    end
  end
end
