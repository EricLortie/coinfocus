class AddNotifications < ActiveRecord::Migration[5.1]
  def change

    create_table :notifications do |t|
      t.string      :n_type
      t.string      :title
      t.text        :body
      t.boolean     :global, :default => false
      t.boolean     :test, :default => false

      t.timestamps
    end

    create_table :coin_notifications do |t|
      t.integer   :coin_id
      t.integer   :notification_id

      t.timestamps
    end
  end
end
