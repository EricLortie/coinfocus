class CreateHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :histories do |t|
      t.integer   :time
      t.decimal   :close, :precision => 20, :scale => 10
      t.decimal   :high, :precision => 20, :scale => 10
      t.decimal   :low, :precision => 20, :scale => 10
      t.decimal   :volumefrom, :precision => 20, :scale => 10
      t.decimal   :volumeto, :precision => 20, :scale => 10
      t.string    :symbolfrom
      t.string    :symbolto
    end
  end
end
