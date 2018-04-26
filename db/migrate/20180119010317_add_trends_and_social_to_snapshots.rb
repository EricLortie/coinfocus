class AddTrendsAndSocialToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :trending_since, :datetime
    add_column :snapshots, :trending_up, :boolean
    add_column :snapshots, :social_data, :text
  end
end
