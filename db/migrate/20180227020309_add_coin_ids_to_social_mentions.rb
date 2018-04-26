class AddCoinIdsToSocialMentions < ActiveRecord::Migration[5.1]
  def change
    add_column :social_mentions, :coin_short_names, :string, array: true, default: []
  end
end
