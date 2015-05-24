require 'spec_helper'

describe UserGiftItemsController do
  let!(:user) { create(:user) }

  describe '#index' do
    context 'When a user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'When a user owns a couple gift_items' do
        let!(:gift_items) { create_list :gift_item, 10, user: user }
        before :each do
          get :index, user_id: user.id
        end
        it 'renders index' do
          expect(response).to render_template(:index)
        end
        it 'renders http success' do
          expect(response.status).to eq 200
        end
        it 'renders all the gift_items for that user' do
          expect(assigns(:gift_items)).to eq GiftItem.for_user(user)
        end
      end
    end
  end

  describe '#edit' do
    context 'when the user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'and a gift item for that user exists' do
        let!(:gift_item) { create :gift_item, user: user }
        before :each do
          get :edit, user_id: user.id, id: gift_item.id
        end
        it 'renders edit' do
          expect(response).to render_template 'edit'
        end
        it 'returns status code 200' do
          expect(response.status).to eq 200
        end
        it 'assigns the correspondent gift_item' do
          expect(assigns(:gift_item)).to eq gift_item
        end
      end
    end
  end

  describe '#update' do
    context 'when the user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      context 'and a gift_item for that gift_item exists' do
        let!(:gift_item) { create :gift_item, user: user }
        before :each do
        end
        it 'should change the title' do
          (expect do
            put :update, user_id: user.id, id: gift_item.id,
                         gift_item: { title: Faker::Lorem.sentence }
          end).to change { gift_item.reload.title }
        end
      end
    end
    context 'when the user is not logged' do
      context 'and a gift_item for that gift_item exists' do
        let!(:gift_item) { create :gift_item, user: user }
        it 'should not change the title' do
          (expect do
            put :update, user_id: user.id, id: gift_item.id,
                         gift_item: { title: Faker::Lorem.sentence }
          end).not_to change { gift_item.reload.title }
        end
      end
    end
  end

  describe '#show' do
    context 'when a gift item for that user exists' do
      let!(:gift_item) { create :gift_item }
      before :each do
        get :show, user_id: user.id, id: gift_item.id
      end

      it 'returns http status 200' do
        expect(response.status).to eq 200
      end
      it 'renders show' do
        expect(response).to render_template 'show'
      end
      it 'renders the correct gift_item' do
        expect(assigns(:gift_item)).to eq gift_item
      end
    end
  end
end
