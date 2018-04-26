
class RedditSubredditWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform
    WorkerModule.capture_subreddit_data
  end
end
