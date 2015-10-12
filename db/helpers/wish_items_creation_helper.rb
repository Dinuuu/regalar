#encoding: utf-8
module WishItemsCreationHelper

  class << self

    def create_wish_items(times)
      puts 'Creating Wish Items'

      1.upto(times) do |time|
        create_wish_item(time)
      end

      puts 'Finished Creating Wish Items'
    end

    private

    def create_wish_item(time)
      wish_item = WishItem.new(
        title: Faker::Commerce.product_name,
        reason: Faker::Lorem.paragraph,
        organization: Organization.all.sample,
        priority: ['low', 'medium', 'high'].sample,
        quantity: Faker::Number.between(100, 200),
        description: Faker::Lorem.paragraph,
        unit: ['kilos', 'liters', 'units'].sample,
        main_image: Rails.root.join('app/assets/images/default_wish_item_pic.jpg').open,
        active: true,
        obtained: 0
      )
    wish_item.save
    end
  end
end