class CreateSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :snapshots do |t|
      t.integer    :coin_id
      t.string     :market
      t.string     :fromsymbol
      t.string     :tosymbol
      t.decimal    :price, :precision => 20, :scale => 2
      t.decimal    :market_cap, :precision => 20, :scale => 2
      t.decimal    :circulating, :precision => 20, :scale => 2
      t.decimal    :volume_24, :precision => 20, :scale => 2
      t.decimal    :last_volume, :precision => 15, :scale => 5
      t.decimal    :last_volume_to, :precision => 15, :scale => 5
      t.decimal    :volume_24, :precision => 20, :scale => 2
      t.decimal    :volume_24_to, :precision => 20, :scale => 2
      t.decimal    :open_24, :precision => 10, :scale => 2
      t.decimal    :high_24, :precision => 10, :scale => 2
      t.decimal    :low_24, :precision => 10, :scale => 2
      t.decimal    :change_24, :precision => 10, :scale => 2
      t.decimal    :change_pct_24, :precision => 10, :scale => 2
      t.decimal    :change_1_week, :precision => 10, :scale => 2
      t.decimal    :change_pct_1_week, :precision => 10, :scale => 2
      t.decimal    :change_1_month, :precision => 10, :scale => 2
      t.decimal    :change_pct_1_month, :precision => 10, :scale => 2
      t.string     :coin_type

      t.timestamps
    end
  end
end
