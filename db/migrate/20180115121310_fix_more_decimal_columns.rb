class FixMoreDecimalColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :snapshots, :mc_change_24, :decimal, default: 0.0
    change_column :snapshots, :mc_change_pct_24, :decimal, default: 0.0
    change_column :snapshots, :mc_change_1_week, :decimal, default: 0.0
    change_column :snapshots, :mc_change_pct_1_week, :decimal, default: 0.0
    change_column :snapshots, :mc_change_1_month, :decimal, default: 0.0
    change_column :snapshots, :mc_change_pct_1_month, :decimal, default: 0.0

    change_column :snapshots, :price_change_24, :decimal, default: 0.0
    change_column :snapshots, :price_change_pct_24, :decimal, default: 0.0
    change_column :snapshots, :price_change_1_week, :decimal, default: 0.0
    change_column :snapshots, :price_change_pct_1_week, :decimal, default: 0.0
    change_column :snapshots, :price_change_1_month, :decimal, default: 0.0
    change_column :snapshots, :price_change_pct_1_month, :decimal, default: 0.0

    change_column :snapshots, :price, :decimal, default: 0.0
    change_column :snapshots, :market_cap, :decimal, default: 0.0
    change_column :snapshots, :circulating, :decimal, default: 0.0
    change_column :snapshots, :volume_24, :decimal, default: 0.0
    change_column :snapshots, :volume_24_to, :decimal, default: 0.0
    change_column :snapshots, :last_volume, :decimal, default: 0.0
    change_column :snapshots, :last_volume_to, :decimal, default: 0.0
    change_column :snapshots, :open_24, :decimal, default: 0.0
    change_column :snapshots, :high_24, :decimal, default: 0.0
    change_column :snapshots, :low_24, :decimal, default: 0.0
  end
end
