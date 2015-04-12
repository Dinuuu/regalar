require 'spec_helper'

describe OrganizationDonationsController do
  let!(:user) { create :user }
  let!(:organization) { create :organization }
  let!(:organization2) { create :organization }
  describe '#confirm' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when user belongs to organization of donation' do
        before :each do
          organization.users << user
        end
        context 'when wish_item is bigger than donation' do
          let!(:wish_item) { create :wish_item, organization: organization, quantity: 4 }
          let!(:donation) do
            create :donation, wish_item: wish_item, user: user,
                              organization: organization, quantity: 2
          end
          it 'increments obtained of wish_item by quant of donation' do
            (expect do
              put :confirm, organization_id: organization.id, id: donation.id
            end).to change { wish_item.reload.obtained }.by(donation.quantity)
          end
          it 'Does not modify quantity of wish_item' do
            (expect do
              put :confirm, organization_id: organization.id, id: donation.id
            end).not_to change { wish_item.reload.quantity }
          end
          it 'sets done of donation to true' do
            (expect do
              put :confirm, organization_id: organization.id, id: donation.id
            end).to change { donation.reload.done }.to(true)
          end
          it 'redirects to wish_item' do
            put :confirm, organization_id: organization.id, id: donation.id
            expect(response)
              .to redirect_to "/organizations/#{organization.id}/wish_items/#{wish_item.id}"
          end
          it 'sends an email' do
            (expect do
              put :confirm, organization_id: organization.id, id: donation.id
            end).to change { ActionMailer::Base.deliveries.count }.by(1)
          end
        end
      end
      context 'when user does not belong to organization' do
        let!(:wish_item) { create :wish_item, organization: organization }
        let!(:donation) do
          create :donation, wish_item: wish_item, user: user, organization: organization
        end
        it 'returns status forbidden' do
          put :confirm, organization_id: organization.id, id: donation.id
          expect(response.status).to eq 403
        end
        it 'does not change the quant of wish_item' do
          (expect do
            put :confirm, organization_id: organization.id, id: donation.id
          end).not_to change { wish_item.reload.quantity }
        end
        it 'does not change done of donation' do
          (expect do
            put :confirm, organization_id: organization.id, id: donation.id
          end).not_to change { donation.reload.done }
        end
        it 'does not send an email' do
          (expect do
            put :confirm, organization_id: organization.id, id: donation.id
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
    context 'When unlogged' do
      let!(:wish_item) { create :wish_item, organization: organization, quantity: 2 }
      let!(:donation) do
        create :donation, wish_item: wish_item, user: user, organization: organization
      end
      it 'should render login page' do
        put :confirm, organization_id: organization.id, id: donation.id
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not change the quant of wish_item' do
        (expect do
          put :confirm, organization_id: organization.id, id: donation.id
        end).not_to change { wish_item.reload.quantity }
      end
      it 'does not change done of donation' do
        (expect do
          put :confirm, organization_id: organization.id, id: donation.id
        end).not_to change { donation.reload.done }
      end
      it 'does not send an email' do
        (expect do
          put :confirm, organization_id: organization.id, id: donation.id
        end).not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
  describe '#cancel' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when user belongs to organization of donation' do
        before :each do
          organization.users << user
        end
        let!(:wish_item) { create :wish_item, organization: organization }
        let!(:donation) do
          create :donation, wish_item: wish_item, user: user, organization: organization
        end
        it 'decrements by 1 the amount of donations' do
          (expect do
            delete :cancel, organization_id: organization.id, id: donation.id
          end).to change { Donation.count }.by(-1)
        end
        it 'redirects to wish_item' do
          delete :cancel, organization_id: organization.id, id: donation.id
          expect(response)
            .to redirect_to "/organizations/#{organization.id}/wish_items/#{wish_item.id}"
        end
        it 'sends an email' do
          (expect do
            delete :cancel, organization_id: organization.id, id: donation.id
          end).to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end
      context 'when user does not belong to organization' do
        let!(:wish_item) { create :wish_item, organization: organization }
        let!(:donation) do
          create :donation, wish_item: wish_item, user: user, organization: organization
        end
        it 'does not change the amount of donations' do
          (expect do
            delete :cancel, organization_id: organization.id, id: donation.id
          end).not_to change { Donation.count }
        end
        it 'returns status forbidden' do
          delete :cancel, organization_id: organization.id, id: donation.id
          expect(response.status).to eq 403
        end
        it 'does not send an email' do
          (expect do
            delete :cancel, organization_id: organization.id, id: donation.id
          end).not_to change { ActionMailer::Base.deliveries.count }
        end
      end
    end
    context 'When unlogged' do
      let!(:wish_item) { create :wish_item, organization: organization }
      let!(:donation) do
        create :donation, wish_item: wish_item, user: user, organization: organization
      end
      it 'should render login page' do
        delete :cancel, organization_id: organization.id, id: donation.id
        expect(response).to redirect_to '/users/sign_in'
      end
      it 'does not change the quant of wish_item' do
        (expect do
          delete :cancel, organization_id: organization.id, id: donation.id
        end).not_to change { wish_item.reload.quantity }
      end
      it 'does not change done of donation' do
        (expect do
          delete :cancel, organization_id: organization.id, id: donation.id
        end).not_to change { donation.reload.done }
      end
      it 'does not send an email' do
        (expect do
          delete :cancel, organization_id: organization.id, id: donation.id
        end).not_to change { ActionMailer::Base.deliveries.count }
      end
    end
  end
  describe '#show' do
    context 'When logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'when user belongs to organization of donation' do
        before :each do
          organization.users << user
        end
        let!(:wish_item) { create :wish_item, organization: organization }
        let!(:donation) do
          create :donation, wish_item: wish_item, user: user, organization: organization
        end
        it 'shows the donation' do
          get :show, organization_id: organization.id, id: donation.id
          expect(response).to render_template 'show'
        end
      end
      context 'when user does not belongs to organization of donation' do
        let!(:wish_item) { create :wish_item, organization: organization }
        let!(:donation) do
          create :donation, wish_item: wish_item, user: user, organization: organization
        end
        it 'returns status forbidden' do
          get :show, organization_id: organization.id, id: donation.id
          expect(response.status).to eq 403
        end
      end
    end
    context 'When unlogged' do
      let!(:wish_item) { create :wish_item, organization: organization }
      let!(:donation) do
        create :donation, wish_item: wish_item, user: user, organization: organization
      end
      it 'should render login page' do
        delete :cancel, organization_id: organization.id, id: donation.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
  describe '#confirmed' do
    let!(:wish_item) { create :wish_item, organization: organization, quantity: 10 }
    let!(:wish_item2) { create :wish_item, organization: organization2, quantity: 10 }
    let!(:donations_done) do
      create_list :donation, 5, wish_item: wish_item, user: user,
                                organization: organization, done: true
    end
    let!(:donations_undone) do
      create_list :donation, 3, wish_item: wish_item, user: user,
                                organization: organization, done: false
    end
    let!(:donations_done2) do
      create_list :donation, 9, wish_item: wish_item2, user: user,
                                organization: organization2, done: true
    end
    let!(:donations_undone2) do
      create_list :donation, 7, wish_item: wish_item2, user: user,
                                organization: organization2, done: false
    end
    before :each do
      get :confirmed, organization_id: organization.id
    end
    context 'asking for confirmed donations' do
      it 'returns donations that are confirmed' do
        expect(assigns(:confirmed).all? { |donation| donation[:done] }).to be true
      end
      it 'returns donations of organization' do
        expect(assigns(:confirmed)
          .all? { |donation| donation[:organization_id] == organization.id }).to be true
      end
      it 'has to be 5' do
        expect(assigns(:confirmed).count).to eq 5
      end
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
      context 'when user belongs to organization' do
        before :each do
          organization.users << user
        end
        let!(:wish_item) { create :wish_item, organization: organization, quantity: 10 }
        let!(:wish_item2) { create :wish_item, organization: organization2, quantity: 10 }
        let!(:donations_done) do
          create_list :donation, 5, wish_item: wish_item, user: user,
                                    organization: organization, done: true
        end
        let!(:donations_undone) do
          create_list :donation, 3, wish_item: wish_item, user: user,
                                    organization: organization, done: false
        end
        let!(:donations_done2) do
          create_list :donation, 9, wish_item: wish_item2, user: user,
                                    organization: organization2, done: true
        end
        let!(:donations_undone2) do
          create_list :donation, 7, wish_item: wish_item2, user: user,
                                    organization: organization2, done: false
        end
        before :each do
          get :pending, organization_id: organization.id
        end
        context 'asking for pending donations' do
          it 'returns donations that are pending' do
            expect(assigns(:pending).all? { |donation| donation[:done] }).to be false
          end
          it 'returns donations of organization' do
            expect(assigns(:pending)
              .all? { |donation| donation[:organization_id] == organization.id }).to be true
          end
          it 'has to be 3' do
            expect(assigns(:pending).count).to eq 3
          end
          it 'renders pending' do
            expect(response).to render_template 'pending'
          end
        end
      end
      context 'when user does not belong to organization' do
        it 'returns status forbidden' do
          get :pending, organization_id: organization.id
          expect(response.status).to eq 403
        end
      end
    end
    context 'When unlogged' do
      it 'should render login page' do
        get :pending, organization_id: organization.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
