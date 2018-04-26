class CreateKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :keywords do |t|
      t.text :keyword

      t.timestamps
    end
  end
end
