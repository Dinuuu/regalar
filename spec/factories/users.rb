# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    before(:create) { |user| user.skip_confirmation! }
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
  end
end
