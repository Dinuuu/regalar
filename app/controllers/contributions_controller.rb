class ContributionsController < ApplicationController

  inherit_resources

  nested_belongs_to :organization, :campaign

  FIELDS = [:amount, :first_name, :last_name, :email, :phone]

  def create
    create! do
      if @contribution.valid?
        # We have to find a way to make the following two lines happen inside inherit resources...
        @contribution.user = current_user if current_user.present?
        @contribution.save!
        handle_valid_contribution
      end
    end
  end

  def anonymous
    fetch_organization
    fetch_campaign
    @contribution = Contribution.new(resource_params.first)
    @contribution.campaign = @campaign
    unless @contribution.save
      return redirect_to new_organization_campaign_contribution_path(@organization, @campaign)
    end
    Purchase.create(status: :success, contribution: @contribution)
    redirect_to organization_campaign_path(@organization, @campaign)
  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:contribution).permit(FIELDS)]
  end

  def handle_valid_contribution
    context = NewContributionContext.new(@contribution, request)
    context.handle
    context.redirect_url if context.success?
  end

  def fetch_organization
    @organization = Organization.find(params[:organization_id])
  end

  def fetch_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end

end
