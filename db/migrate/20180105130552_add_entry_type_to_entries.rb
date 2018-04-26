class AddEntryTypeToEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :entry_type, :string

    create_table :entry_keywords do |t|
      t.integer :entry_id
      t.integer :keyword_id

      t.timestamps
    end
    create_table :content_values do |t|
      t.integer :content_id
      t.string  :content_type
      t.integer :value

      t.timestamps
    end

  end
end
