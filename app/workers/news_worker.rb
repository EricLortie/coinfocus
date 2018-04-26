
class NewsWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform
    WorkerModule.start_news_worker(30)
  end
end
