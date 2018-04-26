class AddLengthToHistories < ActiveRecord::Migration[5.1]
  def change
    add_column :histories, :length, :integer, :default => 86400

  end
end
