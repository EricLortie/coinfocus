class AddRssFeedIdToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :rss_feed_id, :integer
  end
end
