class AddMaxToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :max, :integer, default: 4
  end
end
