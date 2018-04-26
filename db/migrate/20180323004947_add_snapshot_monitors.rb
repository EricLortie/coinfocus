class AddSnapshotMonitors < ActiveRecord::Migration[5.1]
  def change

    create_table :snapshot_monitors do |t|

      t.integer     :coin_id
      t.decimal     :highest_market_cap
      t.integer     :highest_market_cap_id
      t.decimal     :highest_volume
      t.integer     :highest_volume_id
      t.decimal     :highest_circulating
      t.integer     :highest_circulating_id

      t.timestamps
    end
    add_index :snapshot_monitors, :coin_id
    add_index :snapshot_monitors, :highest_market_cap_id
    add_index :snapshot_monitors, :highest_volume_id
    add_index :snapshot_monitors, :highest_circulating_id


    create_table :averages do |t|

      t.integer :coin_id
      t.string  :avg_key
      t.integer :count, :default => 0
      t.decimal :average, :default => 0
      t.decimal :total, :default => 0

    end
    add_index :averages, :coin_id

  end
end
