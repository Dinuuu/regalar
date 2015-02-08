require 'spec_helper'

describe OrganizationsController do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, organizations: [organization]) }
  describe '#index' do
    context 'When user is logged in' do
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
end
