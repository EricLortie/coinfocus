require "sidekiq/web"
Sidekiq::Web.app_url = "/"
Sidekiq::Extensions.enable_delay!
Sidekiq::Web.use(Rack::Auth::Basic, "Application") do |username, password|
  username == ENV.fetch("SIDEKIQ_WEB_USERNAME") &&
    password == ENV.fetch("SIDEKIQ_WEB_PASSWORD")
end
