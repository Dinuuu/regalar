require 'spec_helper'

describe WishItemsController do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organizations: [organization]) }
  describe '#index' do
    before(:each) do
        sign_in user
        user.reload
      end
  	context 'When creating a wish item ' do
  		it 'changes the count of wish items' do
        expect { post :create , wish_item: attributes_for(:wish_item, organization: organization)}
          .to change(WishItem, :count).by(1)
  		end
  	end
  end
end
