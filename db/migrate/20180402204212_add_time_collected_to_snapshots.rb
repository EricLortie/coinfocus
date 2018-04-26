class AddTimeCollectedToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :time_collected, :datetime

    reversible do |dir|
      dir.up { Snapshot.update_all('time_collected = created_at') }
    end

    add_index :snapshots, :time_collected
  end
end
