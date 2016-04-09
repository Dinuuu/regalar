require 'spec_helper'

describe WishItem do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organizations: [organization]) }
  let!(:user2) { create(:user) }
  let!(:wish_item) { create :wish_item, organization: organization }

  describe '#pending_donation' do
    context 'when a donation pending for that wish_item with that user exist' do
      let!(:donation) do
        create :donation, organization: organization,
                          wish_item: wish_item, user: user2, done: false
      end
      it 'returns the pending donation' do
        expect(wish_item.pending_donation(user2)).to eq donation
      end
    end

    context 'when a donation concreted for that wish_item with that user exist' do
      let!(:donation) do
        create :donation, organization: organization,
                          wish_item: wish_item, user: user2, done: true
      end
      it 'returns nil' do
        expect(wish_item.pending_donation(user2)).to be nil
      end
    end

    context 'when no donation for that wish_item with that user exist' do
      it 'returns nil' do
        expect(wish_item.pending_donation(user2)).to be nil
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

  describe '#search' do
    let!(:wish_items_silla) do
      create_list :wish_item, 2, title: 'sillas'
    end
    let!(:wish_items_silla_caps) do
      create_list :wish_item, 2, title: 'SILLA'
    end
    let!(:wish_items_sillas) do
      create_list :wish_item, 3, description: 'Se necesita asillas de interior'
    end
    let!(:wish_items_sillas_caps) do
      create_list :wish_item, 3, description: 'SE NECESITAN AASILLASSSS'
    end
    let!(:wish_items_witout_sillas) do
      create_list :wish_item, 4, title: 'mesas', description: 'Mesas para comer de madera'
    end
    context 'When searching silla' do
      it 'returns 10 results' do
        expected_size = wish_items_silla.count + wish_items_silla_caps.count +
                        wish_items_sillas.count + wish_items_sillas_caps.count
        expect(WishItem.search('silla').count).to eq expected_size
      end
    end
  end

  describe '#pause' do
    context 'when pausing an active wish_item' do
      let!(:wish_item) do
        create :wish_item, active: true
      end
      before :each do
        wish_item.pause
      end
      it 'sets active to false' do
        expect(wish_item.active).to be false
      end
    end
  end

  describe '#resume' do
    context 'when resuming a paused wish_item' do
      let!(:wish_item) do
        create :wish_item, active: false
      end
      before :each do
        wish_item.resume
      end
      it 'sets active to true' do
        expect(wish_item.active).to be true
      end
    end
  end

  describe '#eliminate' do
    context 'when eliminating a not_eliminated_wish_item' do
      let!(:wish_item) do
        create :wish_item, organization: organization, eliminated: false
      end
      it 'sets eliminated to true' do
        expect(wish_item.eliminate).to be true
      end
      it 'changes the count of not eliminated wish items for organization by -1' do
        expect { wish_item.eliminate }
          .to change { organization.wish_items.not_eliminated.count }.by(-1)
      end
      it 'changes the count of eliminated wish items for organization by +1' do
        expect { wish_item.eliminate }.to change { organization.wish_items.eliminated.count }.by(1)
      end
    end
  end
end
