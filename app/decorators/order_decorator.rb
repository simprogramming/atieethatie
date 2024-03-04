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
    subtotal = order_items.sum do |order_item|
      order_item.quantity * order_item.catalog_item_variation.price
    end

    return 0 if subtotal > 50

    total_quantity = order_items.sum(&:quantity)
    if total_quantity > 1
      ((total_quantity - 1) * 3) + 8
    else
      8
    end
  end
end
