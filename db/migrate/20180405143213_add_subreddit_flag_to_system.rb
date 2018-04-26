class AddSubredditFlagToSystem < ActiveRecord::Migration[5.1]
  def change
    add_column :system_variables, :reddit_subreddit_worker_active, :boolean, :default => false
  end
end
