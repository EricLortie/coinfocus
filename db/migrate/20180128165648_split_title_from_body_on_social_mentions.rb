class SplitTitleFromBodyOnSocialMentions < ActiveRecord::Migration[5.1]
  def change
    rename_column :social_mentions, :content, :social_body
    add_column :social_mentions, :social_title, :string
  end
end
