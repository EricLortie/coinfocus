class AddShortTimeframeValsToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :price_change_60m, :decimal
    add_column :snapshots, :price_change_pct_60m, :decimal
    add_column :snapshots, :price_change_30m, :decimal
    add_column :snapshots, :price_change_pct_30m, :decimal
    add_column :snapshots, :vol_change_60m, :decimal
    add_column :snapshots, :vol_change_pct_60m, :decimal
    add_column :snapshots, :vol_change_30m, :decimal
    add_column :snapshots, :vol_change_pct_30m, :decimal
    add_column :snapshots, :mc_change_60m, :decimal
    add_column :snapshots, :mc_change_pct_60m, :decimal
    add_column :snapshots, :mc_change_30m, :decimal
    add_column :snapshots, :mc_change_pct_30m, :decimal
  end
end
