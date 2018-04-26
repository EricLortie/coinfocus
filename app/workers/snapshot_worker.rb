class SnapshotWorker
  include Sidekiq::Worker
  include WorkerModule
  sidekiq_options :unique => :until_and_while_executing

  def perform(coin_id, price_data, time, price)
    WorkerModule.capture_snapshot(coin_id, price_data, time, price)
  end
end
