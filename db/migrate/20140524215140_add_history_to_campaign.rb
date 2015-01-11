class AddHistoryToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :history, :string
  end
end
