require "sidekiq-scheduler"

class CirculationScheduler
  include Sidekiq::Worker

  def perform
    # return if Rails.env != "development"
    Coin.all do |c|
      CoinCirculationWorker.set(:queue => "low_priority").perform_async(c.external_id)
    end
  end
end
