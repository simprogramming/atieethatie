class CartsController < ApplicationController
  include OrderHelper
  before_action { authorize @order || Order }

  def add_item
    @item = CatalogItemVariation.find(cart_item_params[:catalog_item_variation_id])
    @order_item = @order.order_items.find_or_initialize_by(catalog_item_variation: @item)
    @order_item.quantity = item_quantity
    @order_item.save!

    redirect_back(fallback_location: @item)
  end

  private

  def cart_item_params
    params.require(:order_item).permit(:quantity, :catalog_item_variation_id)
  end

  def item_quantity
    return cart_item_params[:quantity] if @order_item.quantity.blank?

    @order_item.quantity += cart_item_params[:quantity].to_i

    @order_item.quantity.positive? ? @order_item.quantity : 1
  end
end
