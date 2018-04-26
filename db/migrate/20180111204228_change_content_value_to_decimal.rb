class ChangeContentValueToDecimal < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :reddit_15m, :integer
    add_column :snapshots, :reddit_15m_sentiment, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :reddit_30m, :integer
    add_column :snapshots, :reddit_30m_sentiment, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :reddit_60m, :integer
    add_column :snapshots, :reddit_60m_sentiment, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :reddit_24h, :integer
    add_column :snapshots, :reddit_24h_sentiment, :decimal, :precision => 10, :scale => 2
  end
end
