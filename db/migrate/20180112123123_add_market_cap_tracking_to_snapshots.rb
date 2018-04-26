class AddMarketCapTrackingToSnapshots < ActiveRecord::Migration[5.1]
  def change

    rename_column :snapshots, :change_24, :price_change_24
    rename_column :snapshots, :change_pct_24, :price_change_pct_24
    rename_column :snapshots, :change_1_week, :price_change_1_week
    rename_column :snapshots, :change_pct_1_week, :price_change_pct_1_week
    rename_column :snapshots, :change_1_month, :price_change_1_month
    rename_column :snapshots, :change_pct_1_month, :price_change_pct_1_month

    add_column :snapshots, :mc_change_24, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :mc_change_pct_24, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :mc_change_1_week, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :mc_change_pct_1_week, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :mc_change_1_month, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :mc_change_pct_1_month, :decimal, :precision => 10, :scale => 2

    add_column :snapshots, :vol_change_24, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :vol_change_pct_24, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :vol_change_1_week, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :vol_change_pct_1_week, :decimal, :precision => 10, :scale => 2
    add_column :snapshots, :vol_change_1_month, :decimal, :precision => 16, :scale => 2
    add_column :snapshots, :vol_change_pct_1_month, :decimal, :precision => 10, :scale => 2

  end
end
