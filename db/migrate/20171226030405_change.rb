class Change < ActiveRecord::Migration[5.1]
  def change
    change_column :social_mentions, :creator_id, :integer, limit: 8
  end
end
