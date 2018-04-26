class UpdateRssWorkflow < ActiveRecord::Migration[5.1]
  def change

    add_column :rss_feeds, :priority, :integer, :default => 0
    add_column :rss_feeds, :last_fetched, :datetime

    create_table :entries do |t|
      t.string    :title
      t.string    :author
      t.string    :foreign_id
      t.text      :content

      t.timestamps
    end

  end
end
