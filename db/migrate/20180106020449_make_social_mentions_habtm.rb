class MakeSocialMentionsHabtm < ActiveRecord::Migration[5.1]
  def change
    remove_column :social_mentions, :coin_id
    remove_column :social_mentions, :keyword_id
    add_column :social_mentions, :url, :string

    create_table :coins_social_mentions do |t|
      t.integer   :coin_id
      t.integer   :social_mention_id
      t.datetime  :posted_at

      t.timestamps
    end

    create_table :social_mentions_keywords do |t|
      t.integer   :social_mention_id
      t.integer   :keyword_id

      t.timestamps
    end

    rename_table :content_values, :content_score
    add_column :content_score, :score_vars, :string

  end
end
