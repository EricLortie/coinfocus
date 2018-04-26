class SaveCoinChartDataToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :chart_data, :text
    add_column :snapshots, :keyword_data, :text
  end
end
