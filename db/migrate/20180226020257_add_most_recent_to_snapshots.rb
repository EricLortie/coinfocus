class AddMostRecentToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :coins, :latest_snapshot_id, :integer
  end
end
