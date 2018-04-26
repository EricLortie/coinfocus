class SocialMentionObliteration < ActiveRecord::Migration[5.1]
  def change

    Average.delete_all
    add_index :averages, [:coin_id, :length, :time, :avg_key], unique: true

    SocialMention.delete_all
    add_index :social_mentions, [:social_id, :social_type], unique: true
    SocialScore.delete_all
    CoinSocialMention.delete_all

    Creator.delete_all
    add_index :creators, [:name, :foreign_id, :creator_type], unique: true

    add_index :keywords, :keyword

  end
end
