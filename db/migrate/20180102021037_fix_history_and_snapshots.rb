class FixHistoryAndSnapshots < ActiveRecord::Migration[5.1]
  def change

    add_column :histories, :coin_id, :integer

  end
end
