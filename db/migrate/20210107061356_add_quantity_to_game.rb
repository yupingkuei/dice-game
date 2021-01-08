class AddQuantityToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :quantity, :integer, default: 0
  end
end
