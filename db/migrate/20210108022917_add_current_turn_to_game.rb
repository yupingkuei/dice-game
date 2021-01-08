class AddCurrentTurnToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :turn, :integer, default: 0
  end
end
