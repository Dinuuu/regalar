require 'spec_helper'

describe OrganizationGiftRequestsController do
  let!(:user) { create :user }
  let!(:user2) { create :user }
  let!(:organization) { create :organization }
  let!(:organization2) { create :organization }
  let!(:gift_item) { create :gift_item, user: user2 }
  byebug
  let!(:gift_request) do
    create :gift_request, organization: organization, user: user, gift_item: gift_item
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
      context 'when creating a valid gift_request' do
        it 'increments the gift_requests by one' do
          (expect do
            post :create, user_id: user.id,
                          id: gift_item.id, gift_request: gift_request.attributes
          end).to change(GiftRequest, :count).by(1)
        end
      end
    end
  end
  describe '#destroy' do

  end
end
