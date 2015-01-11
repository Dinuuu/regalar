class AddMainImageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :main_image, :string
  end
end
