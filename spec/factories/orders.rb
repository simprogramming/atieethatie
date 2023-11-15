FactoryBot.define do
  factory :order do
    session_id { "MyString" }
    paid_at { "2023-11-15 15:30:10" }
    version { 1 }
    square_id { "MyString" }
    state { "MyString" }
  end
end
