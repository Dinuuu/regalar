# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    goal 200.0
    deadline { Time.current + 1.month }
    minimum 1.0
    category 'health'
    locality { Faker::Address.city }
    country { Faker::Address.country }
    short_description { Faker::Lorem.sentence }
  end
end
