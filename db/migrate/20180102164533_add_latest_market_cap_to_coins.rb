class AddLatestMarketCapToCoins < ActiveRecord::Migration[5.1]
  def change

    add_column :coins, :latest_price, :decimal, :precision => 20, :scale => 2
    add_column :coins, :latest_market_cap, :decimal, :precision => 20, :scale => 2

  end
end
