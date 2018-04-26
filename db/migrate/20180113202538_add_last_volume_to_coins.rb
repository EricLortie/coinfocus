class AddLastVolumeToCoins < ActiveRecord::Migration[5.1]
  def change
      add_column :coins, :last_volume, :decimal, :precision => 20, :scale => 2
  end
end
