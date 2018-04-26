
class RedditCommentStreamWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform
    WorkerModule.capture_reddit_comment_stream_data
  end
end
