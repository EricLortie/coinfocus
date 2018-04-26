
class NLPAnalysisWorker
  include Sidekiq::Worker

  def perform(sm_id, message, coin_id)
    return unless sm_id.is_a? Integer

    WorkerModule.keyword_analysis(sm_id, message, coin_id)
  end
end
