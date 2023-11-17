class CartsController < ApplicationController
  include OrderHelper
  before_action { authorize @order || Order }
  skip_before_action :verify_authenticity_token, only: [:checkout]


  def add_item
    @item = CatalogItemVariation.find(cart_item_params[:catalog_item_variation_id])
    @order_item = @order.order_items.find_or_initialize_by(catalog_item_variation: @item)
    @order_item.quantity = item_quantity
    @order_item.save!

    redirect_back(fallback_location: @order)
  end

  def remove_item
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy!

    redirect_back(fallback_location: @order)
  end

  def cart_page
  end

  def checkout
    return unless request.post?

    if true # Remplacez par la condition de succès de votre paiement
      render json: { success: true, message: 'Payment processed successfully.' }, status: :ok
    else
      render json: { success: false, message: 'Payment failed.' }, status: :unprocessable_entity
    end
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
