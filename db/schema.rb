# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180419150120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "averages", force: :cascade do |t|
    t.integer "coin_id"
    t.string "avg_key"
    t.integer "count", default: 0
    t.decimal "average", default: "0.0"
    t.decimal "total", default: "0.0"
    t.integer "length"
    t.integer "time"
    t.index ["coin_id", "length", "time", "avg_key"], name: "index_averages_on_coin_id_and_length_and_time_and_avg_key", unique: true
    t.index ["coin_id"], name: "index_averages_on_coin_id"
  end

  create_table "coin_keywords", force: :cascade do |t|
    t.integer "coin_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "count"
    t.datetime "posted_at"
    t.index ["posted_at"], name: "index_coin_keywords_on_posted_at"
  end

  create_table "coin_notifications", force: :cascade do |t|
    t.integer "coin_id"
    t.integer "notification_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_coin_notifications_on_coin_id"
    t.index ["notification_id"], name: "index_coin_notifications_on_notification_id"
  end

  create_table "coin_social_mentions", force: :cascade do |t|
    t.integer "coin_id"
    t.integer "social_mention_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_coin_social_mentions_on_coin_id"
    t.index ["social_mention_id"], name: "index_coin_social_mentions_on_social_mention_id"
  end

  create_table "coins", force: :cascade do |t|
    t.integer "external_id"
    t.string "short_name"
    t.string "full_name"
    t.string "image_url"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_rss_built"
    t.integer "histories_fetched"
    t.decimal "latest_price", default: "0.0"
    t.decimal "latest_market_cap", default: "0.0"
    t.decimal "last_volume", default: "0.0"
    t.decimal "circulating"
    t.integer "latest_snapshot_id"
    t.index ["latest_snapshot_id"], name: "index_coins_on_latest_snapshot_id"
  end

  create_table "content_score", force: :cascade do |t|
    t.integer "content_id"
    t.string "content_type"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "score_vars"
  end

  create_table "creators", force: :cascade do |t|
    t.string "name"
    t.string "foreign_id"
    t.string "creator_type"
    t.string "organization"
    t.integer "twitter_followers"
    t.integer "facebook_followers"
    t.integer "reddit_followers"
    t.integer "alexa_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.text "description"
    t.string "photo_url"
    t.integer "post_count"
    t.decimal "sentiment"
    t.integer "score"
    t.index ["name", "foreign_id", "creator_type"], name: "index_creators_on_name_and_foreign_id_and_creator_type", unique: true
  end

  create_table "entries", force: :cascade do |t|
    t.string "title"
    t.string "author"
    t.string "foreign_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rss_feed_id"
    t.string "entry_type"
  end

  create_table "entry_keywords", force: :cascade do |t|
    t.integer "entry_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer "external_id"
    t.string "short_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer "time"
    t.decimal "close", precision: 20, scale: 6
    t.decimal "high", precision: 20, scale: 6
    t.decimal "low", precision: 20, scale: 6
    t.decimal "volumefrom", precision: 20, scale: 6
    t.decimal "volumeto", precision: 20, scale: 6
    t.string "symbolfrom"
    t.string "symbolto"
    t.integer "coin_id"
    t.integer "length", default: 86400
    t.index ["coin_id"], name: "index_histories_on_coin_id"
    t.index ["time"], name: "index_histories_on_time"
  end

  create_table "keywords", force: :cascade do |t|
    t.text "keyword"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword"], name: "index_keywords_on_keyword"
  end

  create_table "my_logs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "n_type"
    t.string "title"
    t.text "body"
    t.boolean "global", default: false
    t.boolean "test", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rss_feeds", force: :cascade do |t|
    t.integer "coin_id"
    t.string "rss_type"
    t.string "url"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", default: 0
    t.datetime "last_fetched"
  end

  create_table "snapshot_monitors", force: :cascade do |t|
    t.integer "coin_id"
    t.decimal "highest_market_cap"
    t.integer "highest_market_cap_id"
    t.decimal "highest_volume"
    t.integer "highest_volume_id"
    t.decimal "highest_circulating"
    t.integer "highest_circulating_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "highest_price"
    t.integer "highest_price_id"
    t.index ["coin_id"], name: "index_snapshot_monitors_on_coin_id"
    t.index ["highest_circulating_id"], name: "index_snapshot_monitors_on_highest_circulating_id"
    t.index ["highest_market_cap_id"], name: "index_snapshot_monitors_on_highest_market_cap_id"
    t.index ["highest_volume_id"], name: "index_snapshot_monitors_on_highest_volume_id"
  end

  create_table "snapshots", force: :cascade do |t|
    t.integer "coin_id"
    t.string "market"
    t.string "fromsymbol"
    t.string "tosymbol"
    t.decimal "price", default: "0.0"
    t.decimal "market_cap", default: "0.0"
    t.decimal "circulating", default: "0.0"
    t.decimal "volume_24", default: "0.0"
    t.decimal "last_volume", default: "0.0"
    t.decimal "last_volume_to", default: "0.0"
    t.decimal "volume_24_to", default: "0.0"
    t.decimal "open_24", default: "0.0"
    t.decimal "high_24", default: "0.0"
    t.decimal "low_24", default: "0.0"
    t.decimal "price_change_24", default: "0.0"
    t.decimal "price_change_pct_24", default: "0.0"
    t.decimal "price_change_1_week", default: "0.0"
    t.decimal "price_change_pct_1_week", default: "0.0"
    t.decimal "price_change_1_month", default: "0.0"
    t.decimal "price_change_pct_1_month", default: "0.0"
    t.string "coin_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reddit_15m"
    t.decimal "reddit_15m_sentiment", default: "0.0"
    t.integer "reddit_30m"
    t.decimal "reddit_30m_sentiment", default: "0.0"
    t.integer "reddit_60m"
    t.decimal "reddit_60m_sentiment", default: "0.0"
    t.integer "reddit_24h"
    t.decimal "reddit_24h_sentiment", default: "0.0"
    t.decimal "mc_change_24", default: "0.0"
    t.decimal "mc_change_pct_24", default: "0.0"
    t.decimal "mc_change_1_week", default: "0.0"
    t.decimal "mc_change_pct_1_week", default: "0.0"
    t.decimal "mc_change_1_month", default: "0.0"
    t.decimal "mc_change_pct_1_month", default: "0.0"
    t.decimal "vol_change_24", default: "0.0"
    t.decimal "vol_change_pct_24", default: "0.0"
    t.decimal "vol_change_1_week", default: "0.0"
    t.decimal "vol_change_pct_1_week", default: "0.0"
    t.decimal "vol_change_1_month", default: "0.0"
    t.decimal "vol_change_pct_1_month", default: "0.0"
    t.boolean "change_values_fixed"
    t.decimal "price_change_60m"
    t.decimal "price_change_pct_60m"
    t.decimal "price_change_30m"
    t.decimal "price_change_pct_30m"
    t.decimal "vol_change_60m"
    t.decimal "vol_change_pct_60m"
    t.decimal "vol_change_30m"
    t.decimal "vol_change_pct_30m"
    t.decimal "mc_change_60m"
    t.decimal "mc_change_pct_60m"
    t.decimal "mc_change_30m"
    t.decimal "mc_change_pct_30m"
    t.datetime "trending_since"
    t.boolean "trending_up"
    t.boolean "complete"
    t.integer "news_15m"
    t.decimal "news_15m_sentiment"
    t.integer "news_30m"
    t.decimal "news_30m_sentiment"
    t.integer "news_60m"
    t.decimal "news_60m_sentiment"
    t.integer "news_24h"
    t.decimal "news_24h_sentiment"
    t.text "keyword_data"
    t.integer "twitter_15m"
    t.decimal "twitter_15m_sentiment", default: "0.0"
    t.integer "twitter_30m"
    t.decimal "twitter_30m_sentiment", default: "0.0"
    t.integer "twitter_60m"
    t.decimal "twitter_60m_sentiment", default: "0.0"
    t.integer "twitter_24h"
    t.decimal "twitter_24h_sentiment", default: "0.0"
    t.text "daily_chart_data"
    t.text "weekly_chart_data"
    t.text "monthly_chart_data"
    t.text "yearly_chart_data"
    t.text "daily_social_data"
    t.text "weekly_social_data"
    t.text "monthly_social_data"
    t.text "yearly_social_data"
    t.datetime "time_collected"
    t.index ["coin_id", "complete"], name: "index_snapshots_on_coin_id_and_complete"
    t.index ["coin_id"], name: "index_snapshots_on_coin_id"
    t.index ["complete"], name: "index_snapshots_on_complete"
    t.index ["created_at"], name: "index_snapshots_on_created_at"
    t.index ["id", "complete"], name: "index_snapshots_on_id_and_complete"
    t.index ["time_collected"], name: "index_snapshots_on_time_collected"
    t.index ["updated_at"], name: "index_snapshots_on_updated_at"
  end

  create_table "social_histories", force: :cascade do |t|
    t.integer "coin_id"
    t.integer "time"
    t.integer "length"
    t.integer "reddit_count", default: 0
    t.integer "twitter_count", default: 0
    t.integer "news_count", default: 0
    t.decimal "reddit_sentiment", default: "0.0"
    t.decimal "twitter_sentiment", default: "0.0"
    t.decimal "news_sentiment", default: "0.0"
    t.text "urls"
    t.index ["coin_id"], name: "index_social_histories_on_coin_id"
    t.index ["time"], name: "index_social_histories_on_time"
  end

  create_table "social_mention_keywords", force: :cascade do |t|
    t.integer "social_mention_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_mentions", force: :cascade do |t|
    t.string "social_type"
    t.string "social_id"
    t.text "social_body"
    t.bigint "creator_id"
    t.string "sentiment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.datetime "posted_at"
    t.integer "latest_score", default: 0
    t.string "social_title"
    t.string "coin_short_names", default: [], array: true
    t.index ["posted_at"], name: "index_social_mentions_on_posted_at"
    t.index ["social_id", "social_type"], name: "index_social_mentions_on_social_id_and_social_type", unique: true
    t.index ["social_id"], name: "index_social_mentions_on_social_id"
  end

  create_table "social_score", force: :cascade do |t|
    t.integer "social_mention_id"
    t.integer "likes"
    t.integer "shares"
    t.integer "comments"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "social_scores", force: :cascade do |t|
    t.integer "social_mention_id"
    t.integer "likes"
    t.integer "shares"
    t.integer "comments"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notes"
  end

  create_table "system_variables", force: :cascade do |t|
    t.integer "twitter_stream_active", default: 0
    t.integer "reddit_comment_stream_active", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "reddit_post_stream_active", default: false
    t.boolean "reddit_subreddit_worker_active", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved"
    t.boolean "admin"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "super_user"
    t.string "time_zone"
    t.integer "role", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
