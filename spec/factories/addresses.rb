FactoryBot.define do
  factory :address do
    address_type { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    address_line { "MyString" }
    company { "MyString" }
    apartment { "MyString" }
    city { "MyString" }
    province { "MyString" }
    postal_code { "MyString" }
    country { "MyString" }
    order { nil }
  end
end
