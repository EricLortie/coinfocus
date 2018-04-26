class AddCoinNotificationIndex < ActiveRecord::Migration[5.1]
  def change
    add_index :coin_notifications, :coin_id
    add_index :coin_notifications, :notification_id
  end
end
