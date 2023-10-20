# :nocov:
module Localizable
  extend ActiveSupport::Concern

  module ClassMethods
    def localize_attribute(*attributes)
      attributes.each do |attribute|
        define_method attribute do
          prefix = I18n.locale.to_s.split("-").first

          send("#{attribute}_#{prefix}")
        end

        define_singleton_method "#{attribute}_localized" do
          "#{attribute}_#{I18n.locale}".to_sym
        end
      end
    end
  end
end
# :nocov:
