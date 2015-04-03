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
      wish_item = WishItem.create(
        title: Faker::Commerce.product_name,
        reason: Faker::Lorem.paragraph,
        organization: Organization.all.sample,
        priority: ['low', 'medium', 'high'].sample,
        quantity: Faker::Number.number(2),
        description: Faker::Lorem.paragraph,
        unit: ['kilos', 'liters', 'units'].sample,
        remote_main_image_url: 'http://kevy.com/wp-content/uploads/2013/09/total-product-marketing.jpg'

      )
      wish_item.quantity = 0 if (time % 3) == 0
      wish_item.save!
    end

  end
end