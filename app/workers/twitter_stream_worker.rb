
class TwitterStreamWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform
    WorkerModule.capture_twitter_stream_data
  end
end
