class AddFundingTypeToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :funding_type, :string
  end
end
