require 'spec_helper'

describe WishItemsController do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organizations: [organization]) }
  describe '#create' do
    context 'When creating a wish item while logged ' do
      before(:each) do
        sign_in user
        user.reload
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
    let!(:wish_item) { create(:wish_item, organization_id: organization.id) }

    context 'When destroying a wish item while logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      it 'changes the count of wish items' do
        expect { delete :destroy, organization_id: organization.id, id: wish_item.id }
          .to change(WishItem, :count).by(-1)
      end
      it 'add a wish item to the organization' do
        expect { delete :destroy, organization_id: organization.id, id: wish_item.id }
          .to change(organization.wish_items, :count).by(-1)
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
end
