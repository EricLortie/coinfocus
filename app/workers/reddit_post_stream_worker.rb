
class RedditPostStreamWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform
    WorkerModule.capture_reddit_post_stream_data
  end
end
