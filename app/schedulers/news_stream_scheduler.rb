require "sidekiq-scheduler"

class NewsStreamScheduler
  include Sidekiq::Worker

  def perform
    # timeline = (Time.now.utc - 300).strftime("%Y-%m-%dT%TZ")
    # NewsStreamWorker.set(:queue => "streamer_worker").perform_async(timeline)
  end
end
