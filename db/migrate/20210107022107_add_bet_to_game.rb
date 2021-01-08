class AddBetToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :bet, :integer, array: true, default: []
  end
end
