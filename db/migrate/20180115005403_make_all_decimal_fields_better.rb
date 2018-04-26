class MakeAllDecimalFieldsBetter < ActiveRecord::Migration[5.1]
  def change
    change_column :coins, :latest_price, :decimal, default: 0.0
    change_column :coins, :latest_market_cap, :decimal, default: 0.0
    change_column :coins, :last_volume, :decimal, default: 0.0
    change_column :snapshots, :reddit_15m_sentiment, :decimal, default: 0.0
    change_column :snapshots, :reddit_30m_sentiment, :decimal, default: 0.0
    change_column :snapshots, :reddit_60m_sentiment, :decimal, default: 0.0
    change_column :snapshots, :reddit_24h_sentiment, :decimal, default: 0.0
  end
end
