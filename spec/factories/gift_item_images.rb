FactoryGirl.define do
  factory :gift_item_image do
    file Rack::Test::UploadedFile.new(
    File.open(File.join(Rails.root, '/spec/fixtures/images/default_pic.png')))
  end
end
