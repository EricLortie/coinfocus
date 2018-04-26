class AddCirculatingToCoins < ActiveRecord::Migration[5.1]
  def change
    add_column :coins, :circulating, :decimal
  end
end
