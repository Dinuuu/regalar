FactoryGirl.define do
  factory :gift_item do
    title { Faker::Commerce.product_name }
    quantity { Faker::Number.digit.to_i + 1 }
    unit 'unit'
    description { Faker::Lorem.paragraph }
    used_time 'two years'
    status 'new'
  end
end
