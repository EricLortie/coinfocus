
class TwitterWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform(id, social, keys)
    WorkerModule.capture_tweet_data(id, social, keys)
  end
end
