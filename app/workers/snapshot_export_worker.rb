
class SnapshotExportWorker
  include Sidekiq::Worker
  sidekiq_options :unique => :until_and_while_executing

  def perform(date)
    date = Date.parse(date)
    Snapshot.to_csv(date, (date + 1.day))
  end
end
