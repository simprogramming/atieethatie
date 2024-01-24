class CartsController < ApplicationController
  include OrderHelper
  before_action { authorize @order || Order }

  def add_item
    @item = CatalogItemVariation.find(cart_item_params[:catalog_item_variation_id])
    @order_item = @order.order_items.find_or_initialize_by(catalog_item_variation: @item)
    @order_item.quantity = item_quantity
    @order_item.save!
    redirect_back_with_fallback
  end

  def remove_item
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy!
    redirect_back_with_fallback
  end

  def cart_page
  end

  def checkout
    return if @order.order_items.present?

    redirect_to cart_page_path, alert: "Vous ne pouvez pas faire cette action pour le moment"
  end

  def receipt
    @receipt = Order.find_by(payment_id: params[:id])
  end

  def process_square_payment
    address_serializer = PaymentForms::AddressBuilderSerializer.new(params, @order.id)
    shipping_address = address_serializer.build_address("shipping")
    billing_address = build_billing_address(address_serializer)

    if valid_order_addresses?(shipping_address, billing_address)
      process_payment
    else
      render_order_errors(shipping_address, billing_address)
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

  def redirect_back_with_fallback
    redirect_back(fallback_location: @order)
  end

  def build_billing_address(serializer)
    params[:isBillingChecked] ? nil : serializer.build_address("billing")
  end

  def valid_order_addresses?(shipping, billing)
    shipping.valid? && (params[:isBillingChecked] || billing&.valid?)
  end

  def process_payment
    create_order_service = CreateServices::ObjectOrder.new(
      order: @order,
      token: params[:sourceId],
      verification_token: params[:verificationToken],
      shipping_address: params[:shippingAddress],
      billing_address: params[:billingAddress]
    )
    create_order_service.run!
    render_payment_response
  end

  def render_payment_response
    if @order.payment_id.present?
      InvoiceMailer.with(order: @order).invoice_email_customer.deliver_now
      @order.update!(shipping_status: "pending")
      render json: { success: true, message: "Payment processed successfully.", payment_id: @order.payment_id }, status: :ok
    else
      render json: { success: false, message: "Payment failed." }, status: :unprocessable_entity
    end
  end

  def render_order_errors(shipping, billing)
    errors = PaymentForms::AddressErrorsSerializer.new(shipping, billing).serialize
    render json: { success: false, message: "Please correct the errors.", errors: errors }, status: :unprocessable_entity
  end
end
