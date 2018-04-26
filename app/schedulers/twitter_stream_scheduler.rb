require "sidekiq-scheduler"

class TwitterStreamScheduler
  include Sidekiq::Worker
  sidekiq_options :retry => 5 # Only five retries and then to the Dead Job Queue

  def perform
    # return if Rails.env != "development"
    TwitterStreamWorker.set(:queue => "streamer_worker").perform_async unless SystemVariable.first.twitter_stream_active? or Rails.env.development?
  end
end
