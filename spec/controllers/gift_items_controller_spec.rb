require 'spec_helper'

describe GiftItemsController do
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
        expect(assigns(:gift_items)).to eq GiftItem.all
      end
    end
  end
end
