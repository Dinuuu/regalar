class AddCampaignsStateField < ActiveRecord::Migration
  def self.up
    add_column :campaigns, :aasm_state, :string
  end
  def self.down
    remove_column :campaigns, :aasm_state
  end
end
