module SquareClient
  extend ActiveSupport::Concern
  require "square"

  private

  def client
    @client ||= Square::Client.new(
      access_token: "EAAAEAx-wLezXvyEn1lquznhamRBN8tkPFo89dD-8t14TzIai1SE_iZcpEQZjTZc",
      environment: 'sandbox',
      timeout: 30
    )
  end
end
