class CreateCoinKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :coin_keywords do |t|
      t.integer :coin_id
      t.integer :keyword_id

      t.timestamps
    end
  end
end
