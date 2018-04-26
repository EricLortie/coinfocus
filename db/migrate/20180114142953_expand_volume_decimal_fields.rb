class ExpandVolumeDecimalFields < ActiveRecord::Migration[5.1]
  def change
    change_column :snapshots, :vol_change_24, :decimal, default: 0.0
    change_column :snapshots, :vol_change_pct_24, :decimal, default: 0.0
    change_column :snapshots, :vol_change_1_week, :decimal, default: 0.0
    change_column :snapshots, :vol_change_pct_1_week, :decimal, default: 0.0
    change_column :snapshots, :vol_change_1_month, :decimal, default: 0.0
    change_column :snapshots, :vol_change_pct_1_month, :decimal, default: 0.0
  end
end
