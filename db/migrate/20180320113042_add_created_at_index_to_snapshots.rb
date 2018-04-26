class AddCreatedAtIndexToSnapshots < ActiveRecord::Migration[5.1]
  def change

    add_index :snapshots, :created_at
    add_index :snapshots, :updated_at
    add_index :social_mentions, :posted_at
    add_index :coin_keywords, :posted_at

  end
end
