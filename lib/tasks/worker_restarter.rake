namespace :app_management do
  desc "TODO"
  task :restart_workers => :environment do
    heroku = PlatformAPI.connect_oauth(ENV["PLATFORM_API_TOKEN"])

    worker_ids = heroku.dyno
                       .list(ENV["HEROKU_APP_NAME"])
                       .select { |dyno| dyno["type"].include? "worker" }
                       .map { |dyno| dyno["id"] }

    worker_ids.each do |id|
      heroku.dyno.restart(ENV["HEROKU_APP_NAME"], id)
    end
  end
end
