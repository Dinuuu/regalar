class AddContributionToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :contribution, :float, default: 0.0
  end
end
