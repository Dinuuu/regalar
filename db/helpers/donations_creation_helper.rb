#encoding: utf-8
module DonationsCreationHelper

  class << self

    def create_donations
      puts 'Creating Donations'

      1.upto(WishItem.count) do |wish_item_id|
        create_donation_for_wish_item(wish_item_id)
      end

      puts 'Finished Creating Donations'
    end

    private

    def create_donation_for_wish_item(wish_item_id)
        wish_item = WishItem.find(wish_item_id)
        1.upto((3..10).to_a.sample) do
        donation = Donation.create(
          user: User.all.sample,
          organization: wish_item.organization,
          wish_item: wish_item,
          quantity: Faker::Number.number(2),
          done: [true, false].sample,
        )
        done = true if wish_item.pending_donation(donation.user).present?
        donation.save!
      end
    end
  end
end
