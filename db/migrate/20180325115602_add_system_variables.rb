class AddSystemVariables < ActiveRecord::Migration[5.1]
  def change

        create_table :system_variables do |t|

          t.integer :twitter_stream_active, :default => 0
          t.integer :reddit_stream_active, :default => 0

          t.timestamps

        end

        SystemVariable.create

        add_column :snapshot_monitors, :highest_price, :decimal
        add_column :snapshot_monitors, :highest_price_id, :integer

  end
end