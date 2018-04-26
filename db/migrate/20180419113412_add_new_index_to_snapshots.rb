class AddNewIndexToSnapshots < ActiveRecord::Migration[5.1]
  def change

    add_index :snapshots, [:coin_id, :complete]
  end
end
