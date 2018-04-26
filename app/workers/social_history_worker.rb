
class SocialHistoryWorker
  include Sidekiq::Worker

  def perform(coin_id, s_type, score, link)
    WorkerModule.build_social_history(coin_id, s_type, score, link)
  end
end
