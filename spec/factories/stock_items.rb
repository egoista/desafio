FactoryBot.define do
  factory :stock_item do
    quantity { Faker::Number.digit }
    store
    product
  end
end
