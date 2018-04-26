class AddCreators < ActiveRecord::Migration[5.1]
  def change
    remove_column :social_mentions, :creator_name
    remove_column :social_mentions, :creator_followers


    create_table :creators do |t|
      t.string  :name
      t.string  :foreign_id
      t.string  :creator_type
      t.string  :organization
      t.integer :twitter_followers
      t.integer :facebook_followers
      t.integer :reddit_followers
      t.integer :alexa_rating

      t.timestamps
    end

  end
end
