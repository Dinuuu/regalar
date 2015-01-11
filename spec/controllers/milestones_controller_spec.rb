require 'spec_helper'

describe MilestonesController do

  let(:organization) { create(:organization) }
  let(:campaign) { create(:campaign, organization: organization) }
  let(:milestone) { create(:milestone, campaign: campaign) }
  let(:user) { create(:user, organizations: [organization]) }

  describe 'POST create' do

    context 'When achieving a milestone for a campaign' do

      let(:description) { Faker::Lorem.paragraph }

      before(:each) do
        sign_in(user)
        user.reload
      end

      it 'confirms achieved the milestone' do
        patch :confirm_achieved, organization_id: organization.id,
                                 campaign_id: campaign.id,
                                 id: milestone.id,
                                 milestone: { description: description }
        milestone.reload
        expect(milestone.description).to eq description
        expect(milestone.achieved?).to be true
      end

    end

  end

end
