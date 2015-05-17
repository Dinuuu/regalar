require 'spec_helper'

describe User do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:wish_item) { create :wish_item, organization: organization }
  let!(:level1) { create :level, level: 1, from: 0, to: 10, title: 'Buen Samaritano' }
  let!(:level2) { create :level, level: 2, from: 10, to: 20, title: 'Robin Hood' }
  let!(:level3) { create :level, level: 3, from: 20, to: 30, title: 'Teresa de Calcuta' }

  describe '#level' do
    let!(:donations) do
      create_list :donation, 10, user: user, wish_item: wish_item,
                                 organization: organization, done: true
    end
    context 'When asking for the level of the user' do
      it 'returns the second level' do
        expect(user.level).to eq level2
      end
    end
  end

  describe '#confirmed_donations' do
    context 'When there are existing donations for wish_items' do
      let!(:organization1) { create :organization }
      let!(:organization2) { create :organization }
      let!(:user2) { create :user }
      let!(:wish_items_org1) { create_list :wish_item, 3, organization: organization }
      let!(:wish_items_org2) { create_list :wish_item, 2, organization: organization1 }
      let!(:wish_items_org3) { create_list :wish_item, 4, organization: organization2 }
      let!(:donation1) do
        create :donation, user: user, organization: organization,
                          wish_item: wish_items_org1[0], done: true
      end
      let!(:donation2) do
        create :donation, user: user, organization: organization,
                          wish_item: wish_items_org1[2], done: true
      end
      let!(:donation3) do
        create :donation, user: user, organization: organization1,
                          wish_item: wish_items_org2[1], done: true
      end
      let!(:donation4) do
        create :donation, user: user, organization: organization2,
                          wish_item: wish_items_org3[1], done: false
      end
      let!(:donation4) do
        create :donation, user: user2, organization: organization2,
                          wish_item: wish_items_org3[1], done: true
      end

      it 'returns 2 organizations' do
        expect(user.confirmed_donations.count).to eq 2
      end
      it 'returns donations confirmed' do
        expect(user.confirmed_donations
          .all? { |org_donation| org_donation[:donations].all? { |d| d[:done] } }).to be true
      end
      it 'returns donations for the selected user' do
        expect(user.confirmed_donations
          .all? { |org_donation| org_donation[:donations].all? { |d| d.user_id == user.id } })
          .to eq true
      end
    end
  end

  describe '#level' do
    let!(:donations) do
      create_list :donation, 10, user: user, wish_item: wish_item,
                                 organization: organization, done: true
    end
    context 'When asking for the level of the user' do
      it 'returns the second level' do
        expect(user.level).to eq level2
      end
    end
  end

  describe '#confirmed_gift_requests' do
    context 'When there are existing gift requests for gift_items' do
      let!(:organization1) { create :organization }
      let!(:organization2) { create :organization }
      let!(:user2) { create :user }
      let!(:user3) { create :user }
      let!(:gift_items_org1) { create_list :gift_item, 3, user: user }
      let!(:gift_items_org2) { create_list :gift_item, 2, user: user2 }
      let!(:gift_items_org3) { create_list :gift_item, 4, user: user3 }
      let!(:gift_request) do
        create :gift_request, user: user, organization: organization,
                              gift_item: gift_items_org1[0], done: false
      end
      let!(:gift_request1) do
        create :gift_request, user: user, organization: organization,
                              gift_item: gift_items_org1[0], done: true
      end
      let!(:gift_request2) do
        create :gift_request, user: user, organization: organization2,
                              gift_item: gift_items_org1[2], done: true
      end
      let!(:gift_request3) do
        create :gift_request, user: user2, organization: organization1,
                              gift_item: gift_items_org2[1], done: true
      end
      let!(:gift_request4) do
        create :gift_request, user: user3, organization: organization2,
                              gift_item: gift_items_org3[1], done: false
      end
      let!(:gift_request4) do
        create :gift_request, user: user3, organization: organization2,
                              gift_item: gift_items_org3[1], done: true
      end

      it 'returns 2 organizations' do
        expect(user.confirmed_gift_requests.count).to eq 2
      end
      it 'returns gift_requests confirmed' do
        expect(user.confirmed_gift_requests
          .all? { |org_gift_req| org_gift_req[:gift_requests].all? { |d| d[:done] } }).to be true
      end
      it 'returns gift_requests for the selected user' do
        expect(user.confirmed_gift_requests
          .all? { |org_gift_req| org_gift_req[:gift_requests].all? { |d| d.user_id == user.id } })
          .to eq true
      end
    end
  end
end
