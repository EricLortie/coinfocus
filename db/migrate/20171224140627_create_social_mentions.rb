class CreateSocialMentions < ActiveRecord::Migration[5.1]
  def change

    add_column :coin_keywords, :count, :integer

    create_table :social_mentions do |t|
      t.integer     :coin_id
      t.string      :keyword_id
      t.string      :social_type
      t.integer     :social_id
      t.text        :content
      t.integer     :creator_followers
      t.integer     :creator_id
      t.string      :creator_name
      t.string      :intent

      t.timestamps

    end

    create_table :social_score do |t|
      t.integer     :social_mention_id
      t.integer     :likes
      t.integer     :shares
      t.integer     :comments
      t.integer     :score

      t.timestamps

    end

  end
end
