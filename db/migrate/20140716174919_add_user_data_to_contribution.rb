class AddUserDataToContribution < ActiveRecord::Migration
  def change
    add_column :contributions, :first_name, :string
    add_column :contributions, :last_name, :string
    add_column :contributions, :email, :string
  end
end
