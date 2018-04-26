class AddSnapshotIdAndCompleteIndex < ActiveRecord::Migration[5.1]
  def change
      add_index :snapshots, [:id, :complete]
  end
end
