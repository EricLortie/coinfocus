class AddMoreIndexes < ActiveRecord::Migration[5.1]
  def change
      add_index :coin_social_mentions, :social_mention_id
      add_index :coin_social_mentions, :coin_id
      add_index :snapshots, :coin_id
      add_index :coins, :latest_snapshot_id
  end
end
