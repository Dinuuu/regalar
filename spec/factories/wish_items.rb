FactoryGirl.define do
  factory :wish_item do
    title { Faker::Commerce.product_name }
    reason { Faker::Lorem.paragraph }
    description { Faker::Lorem.paragraph }
    quantity { Faker::Number.digit }
    priority 'medium'
    unit 'liters'
    status 'Disponible'
    main_image Rack::Test::UploadedFile.new(
    File.open(File.join(Rails.root, '/spec/fixtures/images/default_avatar.jpg')))
  end
end
