class AddRssFeeds < ActiveRecord::Migration[5.1]
  def change

    create_table :rss_feeds do |t|
      t.integer     :coin_id
      t.string      :rss_type
      t.string      :url
      t.text        :params

      t.timestamps

    end

  end
end
