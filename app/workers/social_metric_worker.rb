
class SocialMetricWorker
  include Sidekiq::Worker

  def perform(snapshot_id)
    WorkerModule.capture_snapshot_social_data(snapshot_id) if snapshot_id.present?
  end
end
