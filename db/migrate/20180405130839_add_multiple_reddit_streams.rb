class AddMultipleRedditStreams < ActiveRecord::Migration[5.1]
  def change
    rename_column :system_variables, :reddit_stream_active, :reddit_comment_stream_active
    add_column :system_variables, :reddit_post_stream_active, :boolean, :default => false
  end
end
