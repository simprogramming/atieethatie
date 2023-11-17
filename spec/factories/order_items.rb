FactoryBot.define do
  factory :order_item do
    catalog_item_variation { nil }
    order { nil }
    quantity { 1 }
  end
end
