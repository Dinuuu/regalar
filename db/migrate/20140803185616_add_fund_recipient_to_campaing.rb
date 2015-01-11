class AddFundRecipientToCampaing < ActiveRecord::Migration
  def change
    add_column :campaigns, :fund_recipient, :string
  end
end
