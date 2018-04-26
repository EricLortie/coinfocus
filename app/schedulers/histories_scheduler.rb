require "sidekiq-scheduler"

class HistoriesScheduler
  include Sidekiq::Worker

  def perform
    # return if Rails.env != "development"
    WorkerModule.build_histories
  end
end
