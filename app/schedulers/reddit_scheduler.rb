require "sidekiq-scheduler"

class RedditScheduler
  include Sidekiq::Worker

  def perform
    # return if Rails.env != "development"
    WorkerModule.capture_reddit_stream_data(Time.now.utc)
  end
end
