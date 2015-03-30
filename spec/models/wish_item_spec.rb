require 'spec_helper'

describe WishItem do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organizations: [organization]) }
  let!(:user2) { create(:user) }
  let!(:wish_item) { create :wish_item, organization: organization }
  describe '#pending_donation?' do
    context 'when a donation pending for that wish_item with that user exist' do
      let!(:donation) do
        create :donation, organization: organization,
                          wish_item: wish_item, user: user2, done: false
      end
      it 'returns true' do
        expect(wish_item.pending_donation?(user2)).to be true
      end
    end

    context 'when a donation concreted for that wish_item with that user exist' do
      let!(:donation) do
        create :donation, organization: organization,
                          wish_item: wish_item, user: user2, done: true
      end
      it 'returns false' do
        expect(wish_item.pending_donation?(user2)).to be false
      end
    end

    context 'when no donation for that wish_item with that user exist' do
      it 'returns false' do
        expect(wish_item.pending_donation?(user2)).to be false
      end
    end
  end

  describe '#confirmed_donations' do
    context 'When there are existing donations for the wish_item' do
      let!(:donations1) do
        create_list :donation, 5, wish_item: wish_item, organization: organization, user: user
      end
      let!(:donations2) do
        create_list :donation, 5, wish_item: wish_item, organization: organization, user: user2
      end
      context 'and some of those are confirmed' do
        before :each do
          2.times do |time|
            donations2[time].update_attributes!(done: true)
            donations1[time + 1].update_attributes!(done: true)
          end
        end
        it 'returns the quantity of confirmed donations (4)' do
          expect(wish_item.confirmed_donations.count).to eq 4
        end
        it 'returns donations confirmed' do
          expect(wish_item.confirmed_donations
            .all? { |donation| donation[:done] == true }).to be true
        end
        it 'returns donations for the selected user' do
          expect(wish_item.confirmed_donations
            .all? { |donation| donation[:wish_item_id] == wish_item.id }).to eq true
        end
      end
    end
  end
end
