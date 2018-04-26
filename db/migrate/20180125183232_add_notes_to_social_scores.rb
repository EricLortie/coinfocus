class AddNotesToSocialScores < ActiveRecord::Migration[5.1]
  def change
    add_column :social_scores, :notes, :string
  end
end
