worker: bundle exec sidekiq -c 9 -v -q critical -q snapshots -q default -q low_priority -q social
snapshot_worker: bundle exec sidekiq -c 12 -q snapshots
snapshot_exporter: bundle exec sidekiq -c 6 -q snapshot_export
social_worker: bundle exec sidekiq -c 30 -q streamer_worker -q social
release: rake db:migrate

