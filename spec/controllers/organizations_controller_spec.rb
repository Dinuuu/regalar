require 'spec_helper'

describe OrganizationsController do
  let!(:organization) { create(:organization) }
  let!(:user) { create(:user, organizations: [organization]) }
  describe '#index' do
    context 'When a user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      it 'renders all the organizations' do
        get :list
        expect(response).to render_template(:list)
      end
    end
  end

  describe '#create' do
    context 'When a user is logged' do
      before(:each) do
        sign_in user
        user.reload
      end
      it 'increments the count of organizations' do
        expect { post :create, organization: attributes_for(:organization) }
          .to change(Organization, :count).by(1)
      end
      it 'increments the count of organizations for the user' do
        expect { post :create, organization: attributes_for(:organization) }
          .to change(user.organizations, :count).by(1)
      end
    end

    context 'when a user is not logged' do
      it 'does not increment the count of organizations' do
        expect { post :create, organization: attributes_for(:organization) }
          .not_to change { Organization.count }
      end
      it 'does not increment the count of organizations for the user' do
        expect { post :create, organization: attributes_for(:organization) }
          .not_to change { user.organizations }
      end
    end
  end
end
