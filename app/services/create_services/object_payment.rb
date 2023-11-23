module CreateServices
  class ObjectPayment
    include SquareClient

    def initialize(order:, token:, verification_token:, shipping_address:, billing_address:)
      @order = order
      @token = token
      @verification_token = verification_token
      @shipping_address = shipping_address
      @billing_address = billing_address
    end

    def run!
      handle_payment_response(create_payment)
    end

    private

    attr_accessor :order, :token, :shipping_address, :billing_address, :verification_token

    def create_payment
      client.payments.create_payment(
        body: payment_body
      )
    end

    def payment_body
      {
        source_id: token,
        idempotency_key: SecureRandom.uuid,
        amount_money: {
          amount: order.net_amount_due_money.to_i,
          currency: "CAD"
        },
        order_id: order.square_id,
        location_id: "LR7ZE2YVBA61J", # production id 
        verification_token: verification_token,
        buyer_email_address: shipping_address[:email].presence || "",
        billing_address: same_address_checked? ? format_address(shipping_address) : format_address(billing_address),
        shipping_address: format_address(shipping_address)
      }
    end

    def same_address_checked?
      billing_address.blank?
    end

    def format_address(address)
      address_line_1 = address[:address]
      address_line_1 += ", #{address[:apartment]}" if address[:apartment].present?

      {
        address_line_1: address_line_1,
        locality: address[:city],
        postal_code: address[:postalCode],
        country: "CA",
        first_name: address[:firstName],
        last_name: address[:lastName]
      }
    end

    def handle_payment_response(result)
      raise StandardError, result.errors unless result.success?

      update_order_with_payment(result.data[:payment])
    end

    def update_order_with_payment(payment)
      order.payment_id = payment[:id]
      order.receipt_number = payment[:receipt_number]
      order.receipt_url = payment[:receipt_url]
      update_order_state
      store_addresses
    end

    def update_order_state
      result = client.orders.retrieve_order(order_id: order.square_id)
      raise StandardError, result.errors unless result.success?

      order.assign_attributes(
        paid_at: result.data[:order][:closed_at],
        version: result.data[:order][:version],
        state: result.data[:order][:state]
      )
      order.save!
    end

    def store_addresses
      store_address(shipping_address, "shipping") if shipping_address.present?
      store_address(billing_address, "billing") if billing_address.present? && !same_address_checked?
    end

    def store_address(address_data, address_type)
      Address.create!(
        order_id: order.id,
        address_type: address_type,
        first_name: address_data[:firstName],
        last_name: address_data[:lastName],
        address_line: address_data[:address],
        company: address_data[:company],
        apartment: address_data[:apartment],
        city: address_data[:city],
        province: address_data[:province],
        postal_code: address_data[:postalCode],
        country: address_data[:country]
      )
    end
  end
end
