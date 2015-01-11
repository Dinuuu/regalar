class AddPhoneToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :phone, :string
  end
end
