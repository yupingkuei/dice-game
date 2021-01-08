class AddDiceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dice, :integer, array: true, default: []
  end
end
