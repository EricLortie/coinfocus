class AddPostedAtToSocialMentions < ActiveRecord::Migration[5.1]
  def change
      add_column :social_mentions, :posted_at, :datetime
      remove_column :coin_social_mentions, :posted_at
  end
end
