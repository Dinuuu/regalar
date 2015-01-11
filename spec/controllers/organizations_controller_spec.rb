require 'spec_helper'

describe OrganizationsController do

  let(:organization) { create(:organization) }
  let(:user) { create(:user, organizations: [organization]) }

  describe 'GET list' do

    context 'When user is logged in' do

      before(:each) do
        sign_in(user)
        user.reload
      end

      it 'renders all the organizations' do
        get :list
        expect(response).to render_template(:list)
        expect(assigns(:organizations)).to include(organization)
      end

    end

  end

end
