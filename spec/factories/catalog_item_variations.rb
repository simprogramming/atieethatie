FactoryBot.define do
  factory :catalog_item_variation do
    name_fr { "MyString" }
    name_en { "MyString" }
    catalog_item { nil }
    price { 1.5 }
    square_id { "MyString" }
    version { "" }
    image_url { "MyString" }
    color { "MyString" }
    size { "MyString" }
    sku { "MyString" }
  end
end
