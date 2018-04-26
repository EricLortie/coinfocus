
class CoinCirculationWorker
  include Sidekiq::Worker

  def perform(coin_external_id)
    WorkerModule.capture_circulating(coin_external_id)
  end
end
