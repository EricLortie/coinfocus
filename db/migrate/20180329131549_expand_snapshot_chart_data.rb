class ExpandSnapshotChartData < ActiveRecord::Migration[5.1]
  def change

    remove_column :snapshots, :chart_data
    add_column :snapshots, :daily_chart_data, :text
    add_column :snapshots, :weekly_chart_data, :text
    add_column :snapshots, :monthly_chart_data, :text
    add_column :snapshots, :yearly_chart_data, :text

    remove_column :snapshots, :social_data
    add_column :snapshots, :daily_social_data, :text
    add_column :snapshots, :weekly_social_data, :text
    add_column :snapshots, :monthly_social_data, :text
    add_column :snapshots, :yearly_social_data, :text

  end
end
