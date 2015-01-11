class ChangeVideoToUrlFromCampaign < ActiveRecord::Migration
  def change
    change_column :campaigns, :video, :string
  end
end
