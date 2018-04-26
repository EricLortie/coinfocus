
class RedditWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform(id, social, keys)
    WorkerModule.capture_reddit_post_data(id, social, keys)
  end
end
