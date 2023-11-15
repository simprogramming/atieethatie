module CartHelper
  extend ActiveSupport::Concern

  included do
    before_action :set_cart
  end

  private

  def set_cart
    @cart = Order.find_or_create_by(session_id: session[:session_id], paid_at: nil)
  end
end
