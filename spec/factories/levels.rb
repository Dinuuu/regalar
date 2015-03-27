FactoryGirl.define do
  factory :level do
    level 1
    title { Faker::Lorem.word }
    from 1
    to 2
  end
end
