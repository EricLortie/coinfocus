class RenameSocialScoreTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :social_score, :social_scores
  end
end
