Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  devise_for :users, :controllers => { :registrations => "registrations" }
  get "/users/:id/change_password", :action => :change_password, :controller => "users"
  resources :users

  get "/login", :action => :login, :controller => "users"
  get "/login", :action => :register, :controller => "register"

  resources :coins
  resources :snapshots
  resources :rss_feeds

  get "/test_notifications/", :action => :test_notifications, :controller => "notifications"
  get "/test_coin_notifications/", :action => :test_coin_notifications, :controller => "notifications"
  get "/notifications/", :action => :index, :controller => "notifications"

  get "/coin_notifications/:coin_id", :action => :coin_notifications, :controller => "notifications"

  get "/source/:name", :action => :show, :controller => "creators"

  get "/btc_from_prod", :action => :btc_from_prod, :controller => "coins"
  get "/crypto/:coin", :action => :show, :controller => "coins"
  get "/show_coin_from_prod/:id", :action => :show_coin_from_prod, :controller => "coins"
  get "/single_coin_row/:id", :action => :single_coin_row, :controller => "coins"
  get "/chart/:coin_id/:chart/:show_page", :action => :chart, :controller => "coins"
  get "/build_histories", :action => :build_histories, :controller => "coins"
  get "/twitter", :action => :twitter, :controller => "coins"
  get "/fetch_coins", :action => :fetch_coins, :controller => "coins"
  get "/fetch_circulating_values", :action => :fetch_circulating_values, :controller => "coins"

  get "/news", :action => "news", :controller => "social_mentions"
  get "/social", :action => "social", :controller => "social_mentions"
  get "/all_reddit", :action => "reddit", :controller => "social_mentions"
  get "/all_twitter", :action => "twitter", :controller => "social_mentions"
  get "/news/:coin", :action => "news_for_coin", :controller => "social_mentions"
  get "/social/:coin", :action => "social_for_coin", :controller => "social_mentions"
  get "/reddit/:coin", :action => "reddit_for_coin", :controller => "social_mentions"
  get "/twitter/:coin", :action => "twitter_for_coin", :controller => "social_mentions"
  get "/capture_twitter_stream_data", :action => :capture_twitter_stream_data, :controller => "social_mentions"
  get "/fetch_reddit_stream", :action => :fetch_reddit_stream, :controller => "social_mentions"
  get "/test_reddit_post_stream", :action => :test_reddit_post_stream, :controller => "social_mentions"
  get "/test_reddit_comment_stream", :action => :test_reddit_comment_stream, :controller => "social_mentions"
  get "/test_subreddit_worker", :action => :test_subreddit_worker, :controller => "social_mentions"
  get "/test_news_stream", :action => :test_news_stream, :controller => "social_mentions"

  get "/fetch_all_snapshots", :action => :fetch_all_snapshots, :controller => "snapshots"
  get "/queue_all_snapshots", :action => :queue_all_snapshots, :controller => "snapshots"
  get "/build_recent_social_data", :action => :build_recent_social_data, :controller => "snapshots"
  get "/build_snapshot_monitor", :action => :build_snapshot_monitor, :controller => "snapshots"
  get "/calculate_averages_test", :action => :calculate_averages_test, :controller => "snapshots"
  get "/download_snapshots_csv", :action => :download_snapshots_csv, :controller => "snapshots"

  get "/contact", :action => :contact, :controller => "home"
  get "/blog", :action => :blog, :controller => "home"
  get "/about", :action => :about, :controller => "home"
  get "/privacy", :action => :privacy, :controller => "home"
  get "/features", :action => :features, :controller => "home"
  get "/build_recent_data", :action => :build_recent_data, :controller => "home"

  require "sidekiq/web"
  devise_scope :user do
    authenticated :user, ->(u) { u.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
  end

  root "home#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
