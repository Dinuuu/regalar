class ChangeContributionsCampaignPerkField < ActiveRecord::Migration
  def change
    rename_column :contributions, :campaign_perk_id, :perk_id
  end
end
