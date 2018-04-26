
class PreheatWorker
  include Sidekiq::Worker

  def perform(coin_id)
    WorkerModule.preheat_cache_for(coin_id)
  end
end
