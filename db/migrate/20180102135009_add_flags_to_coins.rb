class AddFlagsToCoins < ActiveRecord::Migration[5.1]
  def change

    add_column :coins, :default_rss_built, :integer
    add_column :coins, :histories_fetched, :integer

  end
end
