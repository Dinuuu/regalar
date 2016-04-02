require 'spec_helper'

describe GiftRequest do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:gift_item) { create :gift_item, user: user }
  let!(:gift_request) do
    build(:gift_request, user: user, gift_item: gift_item, organization: organization)
  end
  describe '#create' do
    context 'When creating an invalid gift_request' do
      context 'with no user' do
        before :each do
          gift_request.user_id = nil
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:user_id]).to be_present
        end
      end
      context 'with no gift_item' do
        before :each do
          gift_request.gift_item_id = nil
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:gift_item_id]).to be_present
        end
      end
      context 'with no organization_id' do
        before :each do
          gift_request.organization_id = nil
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:organization_id]).to be_present
        end
      end
      context 'with no quantity' do
        before :each do
          gift_request.quantity = nil
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:quantity]).to be_present
        end
      end
      context 'with negative quantity' do
        before :each do
          gift_request.quantity = - 8
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:quantity]).to be_present
        end
      end
      context 'with quantity 0' do
        before :each do
          gift_request.quantity = 0
        end
        it 'is not valid' do
          expect(gift_request.valid?).to be false
        end
        it 'contains an error' do
          gift_request.valid?
          expect(gift_request.errors[:quantity]).to be_present
        end
      end
    end
    context 'When creating a valid gift_request' do
      it 'is valid' do
        expect(gift_request.valid?).to be true
      end
      it 'has no errors' do
        gift_request.valid?
        expect(gift_request.errors).not_to be_present
      end
      it 'is not done' do
        expect(gift_request.done?).to be false
      end
    end
  end
end
