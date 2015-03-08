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
        title: "Wish Item #{time}",
        reason: Faker::Lorem.paragraph,
        organization: Organization.all.sample,
        status: 'available',
        priority: 'low',
        quantity: 3,
        description: Faker::Lorem.paragraph,
        unit: 'kilos'

      )
      wish_item.save!
    end

  end
end
