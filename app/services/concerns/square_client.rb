module SquareClient
  extend ActiveSupport::Concern
  require "square"

  private

  def client
    @client ||= Square::Client.new(
      access_token: ENV.fetch('SQUARE_ACCESS_TOKEN'),
      environment: 'production',
      timeout: 30
    )
  end
end
