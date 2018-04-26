class SnapshotCronWorker
  include Sidekiq::Worker

  def perform
    open("https://coinfocus.io/fetch_all_snapshots")
  end
end
