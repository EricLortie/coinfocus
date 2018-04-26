require "sidekiq-scheduler"

class SnapshotMonitorScheduler
  include Sidekiq::Worker

  def perform
    WorkerModule.build_snapshot_monitor
  end
end
