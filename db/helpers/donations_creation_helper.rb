#encoding: utf-8
module DonationsCreationHelper

  class << self

    def create_donations
      puts 'Creating Donations'

      WishItem.all.each do |wish_item|
        create_donation_for_wish_item(wish_item)
      end

      puts 'Finished Creating Donations'
    end

    private

    def create_donation_for_wish_item(wish_item)
      total_qty = 0
      1.upto((3..10).to_a.sample) do
        donation = Donation.new(
          user: User.all.sample,
          organization: wish_item.organization,
          wish_item: wish_item,
          quantity: Faker::Number.number(2).to_i + 1,
          done: [true, false].sample,
        )
        donation.done = true if wish_item.pending_donation(donation.user).present?
        total_qty += donation.quantity if donation.done?
        donation.save!
      end
      if (rand < 0.5)
        wish_item.obtained = total_qty
        wish_item.quantity = total_qty
      end
      wish_item.save!
    end
  end
end
