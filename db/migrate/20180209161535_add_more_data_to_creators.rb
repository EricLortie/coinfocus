class AddMoreDataToCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :description, :text
    add_column :creators, :photo_url, :string
    add_column :creators, :post_count, :integer
    add_column :creators, :sentiment, :decimal
    add_column :creators, :score, :integer
  end
end
