require_relative "boot"
require "csv"
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cryptopredict
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Use sidekiq to process Active Jobs (e.g. ActionMailer's deliver_later)
    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_token => ENV["POSTMARK_API_KEY"] }
    config.autoload_paths += %W[#{config.root}/lib]
    config.autoload_paths += %W[#{config.root}/app/services]
    config.assets.paths << Rails.root.join("app", "assets", "images")

    config.i18n.default_locale = :en

    # Ensure non-standard paths are eager-loaded in production
    # (these paths are also autoloaded in development mode)
    # config.eager_load_paths += %W(#{config.root}/lib)

    if defined?(Rails::Server)
      config.after_initialize do
        # Sidekiq::Queue.new("streamer").clear
        SystemVariable.first.update_attributes(:twitter_stream_active => 1, :reddit_comment_stream_active => 1, :reddit_post_stream_active => 1, :reddit_subreddit_worker_active => 1)
        TwitterStreamWorker.set(:queue => "streamer_worker").perform_async unless Rails.env.development?
        RedditPostStreamWorker.set(:queue => "streamer_worker").perform_async unless Rails.env.development?
        RedditCommentStreamWorker.set(:queue => "streamer_worker").perform_async unless Rails.env.development?
        NewsStreamWorker.set(:queue => "streamer_worker").perform_async unless Rails.env.development?
      end
    end

    require "ext/string"
    require "ext/time"
  end
end
