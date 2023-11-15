module OrderHelper
  extend ActiveSupport::Concern

  included do
    before_action :set_order
  end

  private

  def set_order
    @order = Order.find_or_create_by(session_id: session[:session_id], paid_at: nil)
    @order.state = @order.state.presence || "OPEN"
    @order.save!
  end
end
