require 'spec_helper'

describe Donation do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:wish_item) { create :wish_item, organization: organization }
  let!(:donation) do
    build(:donation, user: user, wish_item: wish_item, organization: organization)
  end
  describe '#create' do
    context 'When creating an invalid donation' do
      context 'with no user' do
        before :each do
          donation.user_id = nil
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:user_id]).to be_present
        end
      end
      context 'with no wish_item' do
        before :each do
          donation.wish_item_id = nil
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:wish_item_id]).to be_present
        end
      end
      context 'with no organization_id' do
        before :each do
          donation.organization_id = nil
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:organization_id]).to be_present
        end
      end
      context 'with no quantity' do
        before :each do
          donation.quantity = nil
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:quantity]).to be_present
        end
      end
      context 'with negative quantity' do
        before :each do
          donation.quantity = - 8
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:quantity]).to be_present
        end
      end
      context 'with quantity 0' do
        before :each do
          donation.quantity = 0
        end
        it 'is not valid' do
          expect(donation.valid?).to be false
        end
        it 'contains an error' do
          donation.valid?
          expect(donation.errors[:quantity]).to be_present
        end
      end
    end
    context 'When creating a valid donation' do
      it 'is valid' do
        expect(donation.valid?).to be true
      end
      it 'has no errors' do
        expect(donation.errors).not_to be_present
      end
      it 'is not done' do
        expect(donation.done?).to be false
      end
    end
  end
end
