
class HistoryWorker
  include Sidekiq::Worker

  def perform(h, coin_id, from, to)
    History.create(:time => h["time"], :coin_id => coin_id, :close => h["close"], :high => h["high"], :low => h["low"], :volumeto => h["volumeto"], :volumefrom => h["volumefrom"], :symbolfrom => from, :symbolto => to)
  end
end
