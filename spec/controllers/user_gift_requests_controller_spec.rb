require 'spec_helper'

describe UserGiftRequestsController do
  let!(:user) { create :user }
  let!(:user2) { create :user }
  let!(:organization) { create :organization }
  let!(:organization2) { create :organization }
  let!(:organization3) { create :organization }
  let!(:gift_item) { create :gift_item }
  let!(:gift_item2) { create :gift_item }
  describe '#cancel' do
    before(:each) do
      request.env['HTTP_REFERER'] = organizations_url
    end
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user owns the gift item' do
        before :each do
          gift_item.update_attributes(user: user)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user, gift_item: gift_item
        end
        it 'destroys the gift request' do
          (expect do
            delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id,
                            org: organization
          end).to change { GiftRequest.count }.by(-1)
        end
        it 'sends an email' do
          (expect do
            delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id,
                            org: organization
          end).to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end
      context 'When user does not own the gift item' do
        let!(:user2) { create :user }
        before :each do
          gift_item.update_attributes(user: user2)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user2, gift_item: gift_item
        end
        context 'When trying to cancel a request' do
          it 'responds status forbidden' do
            delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id
            expect(response.status).to eq 403
          end
          it 'does not send an email' do
            (expect do
              delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id
            end).not_to change { ActionMailer::Base.deliveries.count }
          end
        end
      end
    end
    context 'When user is unlogged' do
      before :each do
        gift_item.update_attributes(user: user)
      end
      let!(:gift_request) do
        create :gift_request, organization: organization, user: user, gift_item: gift_item
      end
      it 'should render login page' do
        delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not send an email' do
        (expect do
          delete :cancel, organization_id: organization.id, gift_item_id: gift_item.id
        end).not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
  describe '#show' do
    context 'When user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user owns the gift item' do
        before :each do
          gift_item.update_attributes(user: user)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user, gift_item: gift_item
        end
        it 'render the gift_request' do
          get :show, id: gift_request.id
          expect(response).to render_template :show
        end
        it 'responds status okey' do
          get :show, id: gift_request.id
          expect(response).to be_success
        end
      end
      context 'When user does not own the gift item' do
        let!(:user2) { create :user }
        before :each do
          gift_item.update_attributes(user: user2)
        end
        let!(:gift_request) do
          create :gift_request, organization: organization, user: user2, gift_item: gift_item
        end
        it 'responds status forbidden' do
          get :show, id: gift_request.id
          expect(response.status).to eq 403
        end
      end
    end
    context 'When user is unlogged' do
      before :each do
        gift_item.update_attributes(user: user)
      end
      let!(:gift_request) do
        create :gift_request, organization: organization, user: user, gift_item: gift_item
      end
      it 'should render login page' do
        get :show, id: gift_request.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  describe '#confirmed' do
    before :each do
      gift_item.update_attributes(user: user)
      gift_item2.update_attributes(user: user2)
    end
    let!(:gift_request1) do
      create :gift_request, organization: organization, user: user,
                            gift_item: gift_item, done: true
    end
    let!(:gift_request2) do
      create :gift_request, organization: organization2, user: user,
                            gift_item: gift_item, done: true
    end
    let!(:gift_request3) do
      create :gift_request, organization: organization3, user: user,
                            gift_item: gift_item, done: false
    end
    let!(:gift_request4) do
      create :gift_request, organization: organization, user: user2,
                            gift_item: gift_item, done: true
    end
    let!(:gift_request5) do
      create :gift_request, organization: organization2, user: user2,
                            gift_item: gift_item, done: true
    end
    let!(:gift_request6) do
      create :gift_request, organization: organization3, user: user2,
                            gift_item: gift_item, done: false
    end
    before :each do
      get :confirmed, id: user.id
    end
    context 'asking for confirmed gift_requests' do
      it 'renders confirmed' do
        expect(response).to render_template 'confirmed'
      end
    end
  end
  describe '#pending' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when logged user asks for his pending' do
        before :each do
          get :pending, id: user.slug
        end
        it 'renders pending' do
          expect(response).to render_template 'pending'
        end
      end
      context 'when logged user asks for another users pending' do
        before :each do
          get :pending, id: user2.slug
        end
        it 'returns status forbidden' do
          expect(response.status).to eq 403
        end
      end
    end
    context 'When unlogged' do
      it 'should render login page' do
        get :pending, id: user2.slug
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
