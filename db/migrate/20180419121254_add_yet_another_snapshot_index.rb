class AddYetAnotherSnapshotIndex < ActiveRecord::Migration[5.1]
  def change
      add_index :snapshots, :complete
  end
end
