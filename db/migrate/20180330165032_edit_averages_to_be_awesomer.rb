class EditAveragesToBeAwesomer < ActiveRecord::Migration[5.1]
  def change
    ActiveRecord::Base.connection.execute("TRUNCATE averages")
    add_column :averages, :length, :integer
    add_column :averages, :time, :integer

    # add_index :social_mentions, [:social_id, :social_type], unique: true
  end
end
