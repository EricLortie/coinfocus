class RenameJoinTable < ActiveRecord::Migration[5.1]
  def change

    rename_table :coins_social_mentions, :coin_social_mentions
    rename_table :social_mentions_keywords, :social_mention_keywords

  end
end
