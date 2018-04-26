class AddLatestScoreToSocialMentions < ActiveRecord::Migration[5.1]
  def change
    add_column :social_mentions, :latest_score, :integer, :default => 0
  end
end
