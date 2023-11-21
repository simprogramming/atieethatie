module CreateServices
  class ObjectOrder
    include SquareClient

    def initialize(order:, token:)
      @order = order
      @token = token
    end

    def run!
      handle_order_creation_response(create_square_order)
    end

    private

    attr_accessor :order, :token

    def create_square_order
      client.orders.create_order(
        body: {
          order: {
            location_id: "LJ8SPTZMQP6TS",
            line_items: build_line_items,
            service_charges: [build_service_charge]
          },
          idempotency_key: SecureRandom.uuid
        }
      )
    end

    def handle_order_creation_response(result)
      if result.success?
        store_order_in_database(result.data[:order])
      else
        raise StandardError, result.errors
      end
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
          amount: 1200, # 12$ en centimes
          currency: "CAD"
        },
        calculation_phase: "SUBTOTAL_PHASE"
      }
    end

    def store_order_in_database(order_data)
      net_amount_due = order_data[:net_amounts][:total_money][:amount]

      @order.assign_attributes(
        version: order_data[:version],
        square_id: order_data[:id],
        state: order_data[:state],
        net_amount_due_money: net_amount_due
      )
      @order.save!
      CreateServices::ObjectPayment.new(order: @order, token: token).run!
    end
  end
end
