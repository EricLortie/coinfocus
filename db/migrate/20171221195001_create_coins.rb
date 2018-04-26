class CreateCoins < ActiveRecord::Migration[5.1]
  def change
    create_table :coins do |t|
      t.integer    :external_id
      t.string     :short_name
      t.string     :full_name
      t.string     :image_url
      t.string     :website_url

      t.timestamps
    end
  end
end
