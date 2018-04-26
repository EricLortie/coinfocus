class BuildSocialHistories < ActiveRecord::Migration[5.1]
  def change

    create_table :social_histories do |t|

      t.integer :coin_id
      t.integer :time
      t.integer :length
      t.integer :reddit_count, :default => 0
      t.integer :twitter_count, :default => 0
      t.integer :news_count, :default => 0
      t.decimal :reddit_sentiment, :default => 0.0
      t.decimal :twitter_sentiment, :default => 0.0
      t.decimal :news_sentiment, :default => 0.0
      t.text    :urls

    end

    add_index :social_histories, :coin_id
    add_index :social_histories, :time
    add_index :histories, :coin_id
    add_index :histories, :time

  end
end
