require "sidekiq-scheduler"

class SnapshotScheduler
  include Sidekiq::Worker

  def perform
    coins = Rails.env.development? ? Coin.first : Coin.first(60).drop(10)
    coins.each do |coin|
      price_data = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{coin['short_name']}&tsyms=USD")))
      price_data = price_data["RAW"][coin["short_name"]]["USD"] rescue []
      next if price_data.blank?
      price = price_data["PRICE"].to_f rescue 0
      next if price == 0

      SnapshotWorker.set(:queue => "snapshots").perform_async(coin.id, price_data, Time.now.utc, price)
    end
  end
end
