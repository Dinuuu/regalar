#encoding: utf-8
module GiftItemsCreationHelper

  class << self

    def create_gift_items(times)
      puts 'Creating Gift Items'

      1.upto(times) do |time|
        create_gift_item(time)
      end

      puts 'Finished Creating Gift Items'
    end

    private

    def create_gift_item(time)
      gift_item = GiftItem.new(
        title: Faker::Commerce.product_name,
        user: User.all.sample,
        quantity: Faker::Number.number(2).to_i + 1,
        description: Faker::Lorem.paragraph,
        unit: ['kilos', 'liters', 'units'].sample,
        main_image: Rails.root.join('app/assets/images/default_pic.png').open,
        used_time: 'Dos meses',
        status: 'Como nuevo',
        active: true,
        given: 0
      )
    gift_item.save
    end
  end
end