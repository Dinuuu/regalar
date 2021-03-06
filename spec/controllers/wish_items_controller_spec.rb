require 'spec_helper'

describe WishItemsController do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  describe '#create' do
    context 'When creating a wish item while logged ' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user belongs to organization' do
        before :each do
          organization.users << user
        end
        it 'changes the count of wish items' do
          (expect do
            post :create, organization_id: organization.id,
                          wish_item: attributes_for(:wish_item, organization_id: organization.id)
          end).to change(WishItem, :count).by(1)
        end
        it 'add a wish item to the organization' do
          (expect do
            post :create, organization_id: organization.id,
                          wish_item: attributes_for(:wish_item, organization_id: organization.id)
          end).to change(organization.wish_items, :count).by(1)
        end
      end
      context 'When user does not belong to organization' do
        it 'returns status forbidden' do
          post :create, organization_id: organization.id,
                        wish_item: attributes_for(:wish_item, organization_id: organization.id)
          expect(response.status).to eq 403
        end
      end
    end

    context 'When trying to create a wish item while not logged' do
      it 'does not change the count of wish items' do
        (expect do
          post :create, organization_id: organization.id,
                        wish_item: attributes_for(:wish_item, organization_id: organization.id)
        end).not_to change { WishItem.count }
      end
      it 'does not add a wish item to the organization' do
        (expect do
          post :create, organization_id: organization.id,
                        wish_item: attributes_for(:wish_item, organization_id: organization.id)
        end).not_to change { organization.wish_items.count }
      end
    end
  end

  describe '#destroy' do
    let!(:organization2) { create :organization }
    let!(:wish_item) do
      create :wish_item, organization: organization, quantity: 10,
                         eliminated: false
    end
    let!(:donations_done) do
      create_list :donation, 5, wish_item: wish_item, user: user,
                                organization: organization, done: true
    end
    let!(:donations_undone) do
      create_list :donation, 3, wish_item: wish_item, user: user,
                                organization: organization, done: false
    end
    let!(:donation_params) do
      { reason: 'Me arrepenti' }
    end
    context 'When destroying a not_eliminated wish item while logged' do
      before(:each) do
        sign_in user
        user.reload
        request.env['HTTP_REFERER'] = organizations_url
      end
      context 'When user belongs to organization' do
        before :each do
          organization.users << user
        end
        it 'decrement the donations quantity for wish_item by 3' do
          expect do
            delete :destroy, organization_id: organization.id, id: wish_item.id,
                             donation: donation_params
          end
            .to change { wish_item.reload.donations.count }.by(-3)
        end
        it 'eliminate the 3 pending donations for wish_item' do
          expect do
            delete :destroy, organization_id: organization.id, id: wish_item.id,
                             donation: donation_params
          end
            .to change { wish_item.reload.donations.pending.count }.from(3).to(0)
        end
        it 'does not change the quantity of confirmed donations for wish_item' do
          expect do
            delete :destroy, organization_id: organization.id, id: wish_item.id,
                             donation: donation_params
          end
            .not_to change { wish_item.reload.donations.confirmed.count }
        end
        it 'sends as many emails as pending donations' do
          (expect do
            delete :destroy, organization_id: organization.id, id: wish_item.id,
                             donation: donation_params
          end).to change { ActionMailer::Base.deliveries.count }.by 3
        end
      end
      context 'When user does not belong to organization' do
        it 'returns status forbidden' do
          delete :destroy, organization_id: organization.id, id: wish_item.id
          expect(response.status).to eq 403
        end
      end
    end

    context 'When trying to create a wish item while not logged' do
      it 'does not changes the count of wish items' do
        expect { delete :destroy, organization_id: organization.id, id: wish_item.id }
          .not_to change { WishItem.count }
      end
      it 'does not add a wish item to the organization' do
        expect { delete :destroy, organization_id: organization.id, id: wish_item.id }
          .not_to change { organization.wish_items.count }
      end
    end
  end
  describe '#index' do
    context 'When the user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      it 'renders all the organizations' do
        get :index, organization_id: organization.id
        expect(response).to render_template(:index)
      end
    end
  end

  describe '#show' do
    context 'When the user is logged' do
      before :each do
        sign_in user2
        user2.reload
      end
      context 'when a wish_item exists' do
        let!(:wish_item) { create :wish_item, organization: organization }

        it 'renders show template' do
          get :show, organization_id: organization.id, id: wish_item.id
          expect(response).to render_template(:show)
        end
      end
    end
  end

  describe '#list' do
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
    context "When listing a wish_item with query= 'silla'" do
      it 'returns 10 results' do
        get :list, query: 'silla'
        expected_size = wish_items_silla.count + wish_items_silla_caps.count +
                        wish_items_sillas.count + wish_items_sillas_caps.count
        expect(assigns(:wish_items).count).to eq expected_size
      end
      it 'renders list template' do
        get :list, query: 'silla'
        expect(response).to render_template(:list)
      end
    end
    context 'When listing a wish_item without query' do
      it 'returns 14 results' do
        get :list, query: nil
        expected_size = wish_items_silla.count + wish_items_silla_caps.count +
                        wish_items_sillas.count + wish_items_sillas_caps.count +
                        wish_items_witout_sillas.count
        expect(assigns(:wish_items).count).to eq expected_size
      end
      it 'returns 14 results' do
        get :list, query: ''
        expected_size = wish_items_silla.count + wish_items_silla_caps.count +
                        wish_items_sillas.count + wish_items_sillas_caps.count +
                        wish_items_witout_sillas.count
        expect(assigns(:wish_items).count).to eq expected_size
      end
      it 'returns 14 results' do
        get :list
        expected_size = wish_items_silla.count + wish_items_silla_caps.count +
                        wish_items_sillas.count + wish_items_sillas_caps.count +
                        wish_items_witout_sillas.count
        expect(assigns(:wish_items).count).to eq expected_size
      end
      it 'renders list template' do
        get :list, query: nil
        expect(response).to render_template(:list)
      end
    end
  end

  describe '#pause' do
    let!(:wish_item) { create(:wish_item, organization_id: organization.id) }
    context 'When pausing a wish item while logged ' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user belongs to organization' do
        before :each do
          organization.users << user
        end
      end
      context 'When user does not belong to organization' do
        it 'returns status forbidden' do
          post :pause, organization_id: organization.id, id: wish_item.id
          expect(response.status).to eq 403
        end
      end
    end

    context 'When trying to pause a wish item while not logged' do
      it 'should render login page' do
        post :pause, organization_id: organization.id, id: wish_item.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe '#resume' do
    let!(:wish_item) { create(:wish_item, organization_id: organization.id) }
    context 'When resuming a wish item while logged ' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When user belongs to organization' do
        before :each do
          organization.users << user
        end
      end
      context 'When user does not belong to organization' do
        it 'returns status forbidden' do
          post :resume, organization_id: organization.id, id: wish_item.id
          expect(response.status).to eq 403
        end
      end
    end

    context 'When trying to resume a wish item while not logged' do
      it 'should render login page' do
        post :resume, organization_id: organization.id, id: wish_item.id
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
