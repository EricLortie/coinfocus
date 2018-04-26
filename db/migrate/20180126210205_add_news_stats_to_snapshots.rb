class AddNewsStatsToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :news_15m, :integer
    add_column :snapshots, :news_15m_sentiment, :decimal
    add_column :snapshots, :news_30m, :integer
    add_column :snapshots, :news_30m_sentiment, :decimal
    add_column :snapshots, :news_60m, :integer
    add_column :snapshots, :news_60m_sentiment, :decimal
    add_column :snapshots, :news_24h, :integer
    add_column :snapshots, :news_24h_sentiment, :decimal
  end
end
