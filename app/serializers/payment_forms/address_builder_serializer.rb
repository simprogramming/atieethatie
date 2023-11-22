module PaymentForms
  class AddressBuilderSerializer
    def initialize(params, order_id)
      @params = params
      @order_id = order_id
    end

    def build_address(address_type)
      address_params = @params["#{address_type}Address"]
      return if address_params.blank?

      Address.new(
        order_id: @order_id,
        first_name: address_params[:firstName],
        last_name: address_params[:lastName],
        address_line: address_params[:address],
        company: address_params[:company],
        apartment: address_params[:apartment],
        city: address_params[:city],
        province: address_params[:province],
        postal_code: address_params[:postalCode],
        country: address_params[:country],
        address_type: address_type
      )
    end
  end
end
