FactoryGirl.define do
  factory :wish_item do
    title { Faker::Commerce.product_name }
    reason { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    quantity { Faker::Number.digit }
    priority 'medium'
    unit 'liters'
  end
end
