class ChangeScaleOnDecimalFields < ActiveRecord::Migration[5.1]
  def change

    change_column :histories, :close, :decimal, :precision => 20, :scale => 6
    change_column :histories, :high, :decimal, :precision => 20, :scale => 6
    change_column :histories, :low, :decimal, :precision => 20, :scale => 6
    change_column :histories, :volumefrom, :decimal, :precision => 20, :scale => 6
    change_column :histories, :volumeto, :decimal, :precision => 20, :scale => 6

  end
end
