module CreateServices
  class ObjectOrder
    include SquareClient

    def initialize(order:, token:, verification_token:, shipping_address:, billing_address:)
      @order = order
      @token = token
      @verification_token = verification_token
      @shipping_address = shipping_address
      @billing_address = billing_address
    end

    def run!
      order_response = create_square_order
      handle_order_creation_response(order_response)
    end

    private

    attr_accessor :order, :token, :shipping_address, :billing_address, :verification_token

    def create_square_order
      client.orders.create_order(
        body: {
          order: {
            location_id: "LR7ZE2YVBA61J", # production id
            # location_id: "LJ8SPTZMQP6TS", # sandbox id
            line_items: build_line_items,
            service_charges: [build_service_charge]
          },
          idempotency_key: SecureRandom.uuid
        }
      )
    end

    def handle_order_creation_response(result)
      raise StandardError, result.errors unless result.success?

      store_order_in_database(result.data[:order])
    end

    def build_line_items
      @order.order_items.map do |item|
        build_line_item(item)
      end
    end

    def build_line_item(item)
      {
        quantity: item.quantity.to_s,
        catalog_object_id: item.catalog_item_variation.square_id,
        catalog_version: item.catalog_item_variation.version,
        item_type: "ITEM"
      }
    end

    def build_service_charge
      {
        name: "Shipping Fee",
        amount_money: {
          amount: (@order.decorate.shipping_fee * 100).to_i, # Ensure integer value for amount in cents
          currency: "CAD"
        },
        calculation_phase: "SUBTOTAL_PHASE" # Ensure shipping fee is included in subtotal phase
      }
    end

    def store_order_in_database(order_data)
      net_amount_due = order_data[:net_amounts][:total_money][:amount]

      @order.assign_attributes(
        version: order_data[:version],
        square_id: order_data[:id],
        state: order_data[:state],
        net_amount_due_money: net_amount_due,
        email: shipping_address[:email]
      )
      @order.save!
      process_payment
    end

    def process_payment
      CreateServices::ObjectPayment.new(
        order: @order,
        token: token,
        verification_token: verification_token,
        shipping_address: shipping_address,
        billing_address: billing_address
      ).run!
    end
  end
end
