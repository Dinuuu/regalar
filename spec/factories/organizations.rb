# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name { Faker::Company.name }
    description { Faker::Company.catch_phrase }
    locality { Faker::Address.city }
    email { Faker::Internet.email }
    logo Rack::Test::UploadedFile.new(
    File.open(File.join(Rails.root, '/spec/fixtures/images/default_avatar.jpg')))
  end
end
