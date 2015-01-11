# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :milestone do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    done_date { Time.current }
    amount 100
  end
end
