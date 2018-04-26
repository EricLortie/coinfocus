class AddTwitterMetricsToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :twitter_15m, :integer
    add_column :snapshots, :twitter_15m_sentiment, :decimal, :default => 0.0
    add_column :snapshots, :twitter_30m, :integer
    add_column :snapshots, :twitter_30m_sentiment, :decimal, :default => 0.0
    add_column :snapshots, :twitter_60m, :integer
    add_column :snapshots, :twitter_60m_sentiment, :decimal, :default => 0.0
    add_column :snapshots, :twitter_24h, :integer
    add_column :snapshots, :twitter_24h_sentiment, :decimal, :default => 0.0
  end
end
