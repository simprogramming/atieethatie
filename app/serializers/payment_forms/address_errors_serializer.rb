module PaymentForms
  class AddressErrorsSerializer
    def initialize(shipping_address, billing_address)
      @shipping_address = shipping_address
      @billing_address = billing_address
    end

    def serialize
      @billing_address.valid? if @billing_address.present?

      # Collect errors
      errors = {}
      add_errors(errors, @shipping_address, "shipping") if @shipping_address.present?
      add_errors(errors, @billing_address, "billing") if @billing_address.present?
      errors
    end

    private

    def add_errors(errors, address, prefix)
      address.errors.messages.each do |attribute, messages|
        key = "#{prefix}-#{attribute.to_s.dasherize}"
        errors[key] = messages.join(", ")
      end
    end
  end
end
