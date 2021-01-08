class AddValueToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :value, :integer, default: 2
  end
end
