namespace :app_management do
  desc "TODO"
  task :system_reset => :environment do
    SystemVariable.first.update_attributes(:reddit_comment_stream_active => 0, :reddit_post_stream_active => 0, :twitter_stream_active => 0, :reddit_subreddit_worker_active => 0)
  end
end
