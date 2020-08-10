FactoryBot.define do
  factory :product do
    name { Faker::Beer.name }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end
