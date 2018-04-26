class ChangeSocialIdColumnType < ActiveRecord::Migration[5.1]
  def change
    change_column :social_mentions, :social_id, :string
  end
end
