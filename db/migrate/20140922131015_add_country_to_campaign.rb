class AddCountryToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :country, :string
  end
end
