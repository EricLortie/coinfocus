class CreateMyLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :my_logs do |t|

      t.timestamps
    end
  end
end
