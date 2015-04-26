FactoryGirl.define do
  factory :wish_item do
    title { Faker::Commerce.product_name }
    reason { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    quantity { Faker::Number.digit.to_i + 1 }
    priority 'medium'
    unit 'liters'
    obtained 0
    active true
    main_image Rack::Test::UploadedFile.new(
    File.open(File.join(Rails.root, '/spec/fixtures/images/default_pic.png')))
  end
end
