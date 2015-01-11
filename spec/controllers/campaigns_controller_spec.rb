require 'spec_helper'

describe CampaignsController do

  let(:organization) { create(:organization) }
  let(:campaign) { attributes_for(:campaign) }
  let(:user) { create(:user, organizations: [organization]) }

  describe 'POST create' do

    context 'When creating a campaign correctly for an organization' do

      before(:each) do
        sign_in(user)
        user.reload
      end

      it 'assigns the organization to the campaign' do
        post :create, organization_id: organization.id, campaign: campaign
        expect(Campaign.last.organization).to eq organization
      end

      it 'redirects to the configure campaign view' do
        post :create, organization_id: organization.id, campaign: campaign
        expect(response).to redirect_to configure_campaign_path(Campaign.last)
      end

      it 'creates the campaign' do
        expect do
          post :create, organization_id: organization.id, campaign: campaign
        end.to change(Campaign, :count).by(1)
      end

    end

  end

end
