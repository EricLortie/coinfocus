class AddPostedAtToCoinKeywords < ActiveRecord::Migration[5.1]
  def change
      add_column :coin_keywords, :posted_at, :datetime
  end
end
