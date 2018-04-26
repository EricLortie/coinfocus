class AddCompleteToSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :snapshots, :complete, :boolean
  end
end
