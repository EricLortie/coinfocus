namespace :data_export do
  desc "TODO"
  task :snapshots_to_csv => :environment do
    (Date.parse("January 1st 2018")..Time.zone.today).each do |date|
      Rails.logger.debug("Processing snapshots for #{date}")
      SnapshotExportWorker.set(:queue => "snapshot_export").perform_async(date)
    end
  end
end
