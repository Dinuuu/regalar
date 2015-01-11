class CampaignsController < ApplicationController

  inherit_resources

  before_action :authenticate_user!, except: [:search, :index, :show]
  belongs_to :organization, optional: true

  FIELDS = [:name, :description, :goal, :deadline, :minimum, :category, :short_description,
            :locality, :main_image, :video, :history, :country,
            perks_attributes: [:id, :amount, :name, :maximum, :description,
                               :_destroy, :delivery_date, :requires_address]]

  def search
    @campaigns = Campaign.search(params[:query]).page(params[:page] || 1).per(10)
    render :index
  end

  def index
    index! { @campaigns = @campaigns.page(params[:page] || 1).per(10) }
  end

  def create
    create! do |success|
      if @campaign.valid?
        success.html { redirect_to configure_campaign_path(@campaign) }
      end
    end
  end

  def configure
    @campaign = Campaign.find(params[:id])
  end

  def configure_step2
    @campaign = Campaign.find(params[:id])
    params[:milestones].each do |hash|
      amount = hash[:amount].to_i
      @campaign.milestones << Milestone.create(amount: amount) if amount > 0
    end
    @campaign.fund_recipient = params[:fund_recipient]
    @campaign.funding_type = params[:funding_type]
    @campaign.save!
  end

  def configure_step3
    @campaign = Campaign.find(params[:id])
    @campaign.update_attributes!(resource_params.first)
    redirect_to campaigns_path
  end

  def landing

  end

  private

  def resource_params
    return [] if request.get?
    [params.require(:campaign).permit(FIELDS)]
  end

end
