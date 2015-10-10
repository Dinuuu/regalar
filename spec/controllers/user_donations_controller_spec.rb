require 'spec_helper'

describe UserDonationsController do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:wish_item) { create :wish_item, organization: organization }
  let!(:donation) do
    build(:donation, user: user, organization: organization, wish_item: wish_item)
  end
  before(:each) do
    request.env['HTTP_REFERER'] = organizations_url
  end
  describe '#create' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when creating a valid donation' do
        it 'increments the donations by one' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).to change(Donation, :count).by(1)
        end
        it 'increments the donations for organization by one' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).to change(organization.donations, :count).by(1)
        end
        it 'increments the donations for user by one' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).to change(user.donations, :count).by(1)
        end
        it 'increments the donations for wish_item by one' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).to change(wish_item.donations, :count).by(1)
        end
        it 'sends two emails' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).to change { ActionMailer::Base.deliveries.count }.by(2)
        end
        it 'redirect_to same page' do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
          expect(response).to redirect_to :back
        end
      end
      context 'when trying to create an invalid donation' do
        before :each do
          donation.quantity = 0
        end
        it 'does not increment the donations' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).not_to change { Donation.count }
        end
        it 'renders same page' do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
          expect(response).to render_template :new
        end
        it 'does not send an email' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
      context 'when trying to create a donation on a paused wish item' do
        before :each do
          wish_item.update_attributes!(active: false)
        end
        it 'does not increment the donations' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).not_to change { Donation.count }
        end
        it 'does not send an email' do
          (expect do
            post :create, organization_id: organization.id,
                          id: wish_item.id, donation: donation.attributes
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
    context 'When creating a donation while unlogged ' do
      it 'does not increment the donations' do
        (expect do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
        end).not_to change { Donation.count }
      end
      it 'does not increment the donations for organization' do
        (expect do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
        end).not_to change { organization.donations.count }
      end
      it 'does not increment the donations for user' do
        (expect do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
        end).not_to change { user.donations.count }
      end
      it 'does not increment the donations for wish item' do
        (expect do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
        end).not_to change { wish_item.donations.count }
      end
      it 'should render login page' do
        post :create, organization_id: organization.id,
                      id: wish_item.id, donation: donation.attributes
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not send an email' do
        (expect do
          post :create, organization_id: organization.id,
                        id: wish_item.id, donation: donation.attributes
        end).not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
  describe '#destroy' do
    let!(:cancelation_params) { { reason: Faker::Lorem.paragraph } }
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when own a donation' do
        before :each do
          donation.wish_item_id = wish_item.id
          donation.save!
        end
        context 'when canceling it' do
          it 'decrements by 1 the amount of donations' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).to change(Donation, :count).by(-1)
          end
          it 'decrements by 1 the amount of user donations' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).to change(user.donations, :count).by(-1)
          end
          it 'decrements by 1 the amount of organization donations' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).to change(organization.donations, :count).by(-1)
          end
          it 'decrements by 1 the amount of wish item donations' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).to change(wish_item.donations, :count).by(-1)
          end
          it 'sends two emails' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).to change { ActionMailer::Base.deliveries.count }.by(2)
          end
        end
      end
      context 'when a donation that is not mine exists' do
        let(:user2) { create :user }
        before :each do
          donation.wish_item_id = wish_item.id
          donation.user_id = user2.id
          donation.save!
        end
        it 'returns status forbidden' do
          delete :destroy, id: donation.id, donation: cancelation_params
          expect(response.status).to eq 403
        end
        it 'does not changes the amount of donations' do
          expect { delete :destroy, id: donation.id, donation: cancelation_params }
            .not_to change { Donation.count }
        end
        it 'does not send an email' do
          (expect do
            delete :destroy, id: donation.id, donation: cancelation_params
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
      context 'when a donation does not exist' do
        it 'raise record not found' do
          expect { delete :destroy, id: 0, donation: cancelation_params }
            .to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
    context 'When unlogged' do
      context 'when a donation exists' do
        before :each do
          donation.wish_item_id = wish_item.id
          donation.save!
        end
        context 'when canceling it' do
          it 'should render login page' do
            delete :destroy, id: donation.id, donation: cancelation_params
            expect(response).to redirect_to '/users/sign_in'
          end
          it 'does not changes the amount of donations' do
            expect { delete :destroy, id: donation.id, donation: cancelation_params }
              .not_to change { Donation.count }
          end
          it 'does not send an email' do
            (expect do
              delete :destroy, id: donation.id, donation: cancelation_params
            end).not_to change { ActionMailer::Base.deliveries.count }
          end
        end
      end
    end
  end
end
