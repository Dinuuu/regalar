#encoding: utf-8
module GiftRequestsCreationHelper

  class << self

    def create_gift_requests
      puts 'Creating GiftRequests'

      GiftItem.all.each do |gift_item|
        create_gift_request_for_gift_item(gift_item)
      end

      puts 'Finished Creating GiftRequests'
    end

    private

    def create_gift_request_for_gift_item(gift_item)
      total_qty = 0
      1.upto((3..10).to_a.sample) do
        gift_request = GiftRequest.new(
          user: gift_item.user,
          organization: Organization.all.sample,
          gift_item: gift_item,
          quantity: Faker::Number.number(2).to_i + 1,
          done: [true, false].sample,
        )
        gift_request.done = true if gift_item.pending_gift_request(gift_request.user).present?
        total_qty += gift_request.quantity if gift_request.done?
        gift_request.save!
      end
      if (rand < 0.5)
        gift_item.given = total_qty
        gift_item.quantity = total_qty
      end
      gift_item.save!
    end
  end
end
