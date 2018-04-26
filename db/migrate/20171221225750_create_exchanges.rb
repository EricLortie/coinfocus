class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.integer    :external_id
      t.string     :short_name

      t.timestamps
    end
  end
end
