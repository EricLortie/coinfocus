class RenameSocialMentionIntentColumn < ActiveRecord::Migration[5.1]
  def change

    rename_column :social_mentions, :intent, :sentiment

  end
end