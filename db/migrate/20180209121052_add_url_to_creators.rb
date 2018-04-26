class AddUrlToCreators < ActiveRecord::Migration[5.1]
  def change
    add_column :creators, :url, :string
  end
end
