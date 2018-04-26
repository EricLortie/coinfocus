class AddIndexToSocialMentions < ActiveRecord::Migration[5.1]
  def change

    add_index :social_mentions, :social_id

  end
end
