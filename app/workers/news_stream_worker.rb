
class NewsStreamWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform(timeline=(Time.now.utc - 900).strftime("%Y-%m-%dT%TZ"))
    WorkerModule.start_news_worker(2, timeline)
  end
end
