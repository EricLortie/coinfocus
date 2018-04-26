class AddValuesFixedToSnapshots < ActiveRecord::Migration[5.1]
  def change
      add_column :snapshots, :change_values_fixed, :boolean
  end
end
