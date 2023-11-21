module CreateServices
  class ObjectPayment
    include SquareClient

    def initialize(order:, token:)
      @order = order
      @token = token
    end

    def run!
      handle_payment_response(create_payment)
    end

    private

    attr_accessor :order, :token

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
        location_id: "LJ8SPTZMQP6TS"
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
  end
end
