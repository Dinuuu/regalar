require 'spec_helper'

describe GiftItemsController do
  let!(:user) { create :user }
  describe '#index' do
    context 'when gift_items exists for differents users' do
      let!(:user1) { create :user }
      let!(:user2) { create :user }
      let!(:gift_items1) { create_list :gift_item, 10, user: user1 }
      let!(:gift_items2) { create_list :gift_item, 8, user: user2 }
      before :each do
        get :index
      end
      it 'render index' do
        expect(response).to render_template 'index'
      end
      it 'assigns all the GiftItems' do
        expect(assigns(:gift_items)).to eq GiftItem.still_available
      end
    end
  end

  describe '#create' do
    context 'When a user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      it 'increments the count of gift_items' do
        (expect do
          post :create, gift_item: attributes_for(:gift_item)
        end).to change(GiftItem, :count).by(1)
      end
      it 'redirects' do
        post :create, gift_item: attributes_for(:gift_item)
        expect(response.status).to eq 302
      end
    end

    context 'when a user is not logged' do
      it 'does not increment the count of organizations' do
        (expect do
          post :create, gift_item: attributes_for(:gift_item)
        end).not_to change { GiftItem.count }
      end
      it 'redirects to login' do
        post :create, gift_item: attributes_for(:gift_item)
        expect(response.status).to eq 302
      end
    end
  end

  describe '#new' do
    context 'when the user is logged' do
      before(:each) do
        sign_in user
        user.reload
        get :new
      end
      it 'renders the new template' do
        expect(response).to render_template 'new'
      end
      it 'returns http status 200' do
        expect(response.status).to eq 200
      end
    end
  end
end
