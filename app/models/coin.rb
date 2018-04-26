# == Schema Information
#
# Table name: coins
#
#  circulating        :decimal(, )
#  created_at         :datetime         not null
#  default_rss_built  :integer
#  external_id        :integer
#  full_name          :string
#  histories_fetched  :integer
#  id                 :integer          not null, primary key
#  image_url          :string
#  last_volume        :decimal(, )      default(0.0)
#  latest_market_cap  :decimal(, )      default(0.0)
#  latest_price       :decimal(, )      default(0.0)
#  latest_snapshot_id :integer
#  short_name         :string
#  updated_at         :datetime         not null
#  website_url        :string
#
# Indexes
#
#  index_coins_on_latest_snapshot_id  (latest_snapshot_id)
#

class Coin < ApplicationRecord
  has_many :coin_keywords, :dependent => :destroy
  has_many :snapshots, :dependent => :destroy
  has_one :latest_snapshot, :class_name => "Snapshot", :foreign_key => "latest_snapshot_id", :inverse_of => :coin, :dependent => :destroy
  has_many :histories, :dependent => :destroy
  has_many :social_histories, :dependent => :destroy
  has_many :averages, :dependent => :destroy
  has_many :rss_feeds, :dependent => :destroy
  has_many :keywords, :through => :coin_keywords, :inverse_of => :coin
  has_many :coin_social_mentions, :dependent => :destroy
  has_many :social_mentions, :through => :coin_social_mentions
  has_many :coin_notifications, :dependent => :destroy
  has_many :notifications, :through => :coin_notifications

  default_scope { order(:latest_market_cap => :desc) }

  # Start trying to figure out what coins/altcoins are important enough to track social media traffic on
  def important?
    # return true if id == 1
    false
  end

  def latest_snapshot
    snapshots.find(latest_snapshot_id)
  end

  def previous_snapshot
    snapshots.second
  end

  # Methods for calculating market cap changes
  def price_change(timeframe, percent=false, default=0)
    return (ApplicationController.helpers.parse_change(latest_price, price_history_at(timeframe, default)) rescue default) unless percent
    return (ApplicationController.helpers.parse_change_pct(latest_price, price_history_at(timeframe, default)) rescue default) if percent
  end

  def price_history_at(time_stamp, default)
    ret = snapshots.find_by("complete IS NOT NULL AND time_collected <= ?", time_stamp).price.to_f rescue ""
    if ret.blank?
      ret = histories.find_by("time <= ?", Time.parse(time_stamp.to_s).to_i).close.to_f
    end
    ret = default if ret.blank?
    ret
  end

  # Methods for calculating market cap changes
  def mc_change(timeframe, percent=false, default=0)
    h = mc_history_at(timeframe, default)
    return 0 if h == default
    return ApplicationController.helpers.parse_change(latest_market_cap, h) unless percent
    return ApplicationController.helpers.parse_change_pct(latest_market_cap, h) if percent
  end

  def mc_history_at(time_stamp, _default)
    snapshots.find_by("complete IS NOT NULL AND time_collected <= ?", time_stamp).market_cap.to_f rescue 0.0
  end

  # Methods for calculating market cap changes
  def vol_change(timeframe, percent=false, default=0)
    h = vol_history_at(timeframe, default)
    return 0 if h == default
    return ApplicationController.helpers.parse_change(last_volume, h) unless percent
    return ApplicationController.helpers.parse_change_pct(last_volume, h) if percent
  end

  def vol_history_at(time_stamp, _default)
    snapshots.find_by("complete IS NOT NULL AND time_collected <= ?", time_stamp).volume_24_to.to_f rescue 0.0
  end

  def social_mention_stats
    ret = Rails.cache.fetch("social_mention_stats_#{id}")
    if ret.blank?
      ret = {}
      ret[:one_hour] = 0
      ret[:one_hour_sentiment] = 0
      ret[:one_day] = 0
      ret[:one_day_sentiment] = 0
    end
    ret
  end

  def last_social_mention
    social_mentions.order("posted_at DESC").first
  end

  def keyword_data
    ret = {}
    halfhour = Hash.new(0)
    ret[:halfhour] = {}
    hour = Hash.new(0)
    ret[:hour] = {}
    day = Hash.new(0)
    ret[:day] = {}
    # week = Hash.new(0)
    ret[:week] = {}
    # month = Hash.new(0)
    ret[:month] = {}
    # year = Hash.new(0)
    ret[:year] = {}
    ret[:halfhour][:labels] = []
    ret[:halfhour][:data] = []
    ret[:hour][:labels] = []
    ret[:hour][:data] = []
    ret[:day][:labels] = []
    ret[:day][:data] = []
    # ret[:week][:labels] = []
    # ret[:week][:data] = []
    # ret[:month][:labels] = []
    # ret[:month][:data] = []
    # ret[:year][:labels] = []
    # ret[:year][:data] = []

    keywords = CoinKeyword.where("coin_id = ? AND posted_at > ? ", id, 1.day.ago.to_s)
    if keywords.present?
      keywords.each do |k|
        next if k.keyword.blank?
        kword = k.keyword.keyword
        coin = k.coin
        next if kword.blank? or [coin.short_name.downcase, coin.full_name.downcase].include?(kword.downcase)
        time = Time.zone.at(k.posted_at)
        halfhour[kword] += 1 if time > 30.minutes.ago.to_s
        hour[kword] += 1 if time > 60.minutes.ago.to_s
        day[kword] += 1 if time > 24.hours.ago.to_s
        # week[kword] += 1 if time > 1.week.ago.to_s
        # month[kword] += 1 if time > 1.month.ago.to_s
        # year[kword] += 1 if time > 1.year.ago.to_s
      end
    end

    halfhour.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:halfhour][:labels].push(k); ret[:halfhour][:data].push(v) }
    hour.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:hour][:labels].push(k); ret[:hour][:data].push(v) }
    day.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:day][:labels].push(k); ret[:day][:data].push(v) }
    # week.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:week][:labels].push(k); ret[:week][:data].push(v) }
    # month.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:month][:labels].push(k); ret[:month][:data].push(v) }
    # year.sort_by { |_key, value| value }.last(10).each { |k, v| ret[:year][:labels].push(k); ret[:year][:data].push(v) }

    ret
  end

  def coin_chart_data(timeframe="week")
    Rails.cache.fetch "#{latest_snapshot_id}-#{timeframe}-chart #{Time.now.utc.to_f if Rails.env.development?}" do
      ret = {}
      ret[:day] = {}
      ret[:week] = {}
      ret[:month] = {}
      ret[:year] = {}
      ret[:day][:labels] = []
      ret[:day][:data] = []
      ret[:week][:labels] = []
      ret[:week][:data] = []
      ret[:month][:labels] = []
      ret[:month][:data] = []
      ret[:year][:labels] = []
      ret[:year][:data] = []

      if timeframe == "day"
        snapshot_period = 1.day.ago.utc
      elsif timeframe == "week"
        snapshot_period = 1.week.ago.utc
      elsif timeframe == "month"
        snapshot_period = 1.month.ago.utc
      elsif timeframe == "year"
        snapshot_period = 1.year.ago.utc
      end

      # snapshots = Snapshot.select("snapshots.id, snapshots.time_collected, snapshots.price").where("coin_id = ? AND time_collected > ? ", id, snapshot_period.to_s)
      histories = History.select("histories.id, histories.time, histories.close").where("coin_id = ? AND time > ? ", id, snapshot_period.to_i)
      count = 0
      histories.each do |h|
        time = Time.zone.at(h.time)
        next if time > Time.now.utc
        price = h.close.to_f
        if time > 1.day.ago.to_s
          ret[:day][:labels].push(time)
          ret[:day][:data].push(price)
        end
        if time > 1.week.ago.to_s
          ret[:week][:labels].push(time)
          ret[:week][:data].push(price)
        end
        if count.even? and time > 1.month.ago.to_s
          ret[:month][:labels].push(time)
          ret[:month][:data].push(price)
        end
        if count % 5 == 0 and time > 1.year.ago.to_s
          ret[:year][:labels].push(time)
          ret[:year][:data].push(price)
        end
        count += 1
      end

      ret
    end
  end

  def social_chart_data(timeframe="week")
    Rails.cache.fetch "#{latest_snapshot_id}-social #{Time.now.utc.to_f if Rails.env.development?}" do
      ret = {}
      ret[:values] = false
      ret[:day] = {}
      ret[:week] = {}
      ret[:month] = {}
      ret[:year] = {}
      ret[:day][:labels] = []
      ret[:day][:data] = []
      ret[:day][:links] = []
      ret[:week][:labels] = []
      ret[:week][:data] = []
      ret[:week][:links] = []

      period = timeframe == "day" ? 1.day.ago.utc : 1.week.ago.utc
      # period = 1.day.ago.utc

      # social_mentions.select("social_mentions.id, social_mentions.posted_at, social_mentions.url, social_mentions.sentiment, social_mentions.social_type").where("posted_at > ? AND latest_score > ?", period, 5).find_each do |sm|

      social_histories = SocialHistory.where("coin_id = ? AND time > ? ", id, period.to_i)
      # return social_histories.length
      social_histories.each do |sh|
        time = Time.zone.at(sh.time).utc
        ret[:values] = true

        data = {
          :twitter_count => sh[:twitter_count],
          :twitter_sentiment => sh[:twitter_sentiment],
          :reddit_count => sh[:reddit_count],
          :reddit_sentiment => sh[:reddit_sentiment],
          :news_count => sh[:news_count],
          :news_sentiment => sh[:news_sentiment]
        }

        if time > period
          ret[:week][:labels].push(time)
          ret[:week][:data].push(data)
          ret[:week][:links].push(sh[:urls])
        end
        next unless time > period
        ret[:day][:labels].push(time)
        ret[:day][:data].push(data)
        ret[:day][:links].push(sh[:urls])
      end
      ret
    end
  end

  def chart_data(_timeframe="week")
    # Rails.cache.fetch "chart_data #{id}" :expires_in => 3.minutes do
    ret = {}
    ret[:day] = {}
    ret[:week] = {}
    ret[:month] = {}
    ret[:year] = {}
    ret[:day][:labels] = []
    ret[:day][:data] = {}
    ret[:week][:labels] = []
    ret[:week][:data] = {}
    ret[:month][:labels] = []
    ret[:month][:data] = {}
    ret[:year][:labels] = []
    ret[:year][:data] = {}

    # snapshots = Snapshot.select("snapshots.id, snapshots.time_collected, snapshots.price").where("coin_id = ? AND time_collected > ? ", id, snapshot_period.to_s)
    histories = History.select("histories.id, histories.time, histories.close, histories.length").where("coin_id = ? AND time > ? ", id, 1.year.ago.utc.to_i)
    count = 0
    histories.each do |h|
      time = Time.zone.at(h.time).utc.round_off(10 * 60)
      t_int = h.time.to_i
      next if time > Time.now.utc

      empty_social_data = {
        :twitter_count => 0,
        :twitter_sentiment => 0,
        :reddit_count => 0,
        :reddit_sentiment => 0,
        :news_count => 0,
        :news_sentiment => 0
      }

      price = h.close.to_f
      if time > 1.day.ago.utc.to_s
        ret[:day][:data][t_int] ||= {}
        ret[:day][:labels].push(t_int) unless ret[:day][:labels].include? t_int
        ret[:day][:data][t_int][:social] ||= empty_social_data
        ret[:day][:data][t_int][:price] = price
      end
      if time > 1.week.ago.utc.to_s
        ret[:week][:data][t_int] ||= {}
        ret[:week][:labels].push(t_int) unless ret[:week][:labels].include? t_int
        ret[:week][:data][t_int][:social] ||= empty_social_data
        ret[:week][:data][t_int][:price] = price
      end
      if count.even? and time > 1.month.ago.utc.to_s
        ret[:month][:data][t_int] ||= {}
        ret[:month][:labels].push(t_int)
        ret[:month][:data][t_int][:price] = price
      end
      if count % 5 == 0 and time > 1.year.ago.utc.to_s
        ret[:year][:data][t_int] ||= {}
        ret[:year][:labels].push(t_int)
        ret[:year][:data][t_int][:price] = price
      end
      count += 1
    end

    social_histories = SocialHistory.where("coin_id = ? AND time > ? ", id, 1.week.ago.utc.to_i)
    # return social_histories.length
    social_histories.each do |sh|
      time = Time.zone.at(sh.time).utc.round_off(10 * 60)
      t_int = sh.time.to_i
      ret[:values] = true

      data = {
        :twitter_count => sh[:twitter_count],
        :twitter_sentiment => sh[:twitter_sentiment],
        :reddit_count => sh[:reddit_count],
        :reddit_sentiment => sh[:reddit_sentiment],
        :news_count => sh[:news_count],
        :news_sentiment => sh[:news_sentiment]
      }

      if time > 1.week.ago.utc.to_s
        if ret[:week][:data][t_int].blank?
          keys = ret[:week][:data].keys
          key = keys.sort.reverse.find { |e| e < t_int } || keys.find { |e| e > t_int }
          ret[:week][:labels].push(t_int) unless ret[:week][:labels].include? t_int
          ret[:week][:data][key][:social] = data
          data.map { |k, v| ret[:week][:data][key][:social][k] += v }

        else
          ret[:week][:data][t_int][:social] ||= {}
          data.map { |k, v| ret[:week][:data][t_int][:social][k] += v }
        end
      end

      next if time < 1.day.ago.utc.to_s
      if ret[:day][:data][t_int].blank?
        keys = ret[:day][:data].keys
        key = keys.sort.reverse.find { |e| e < t_int } || keys.find { |e| e > t_int } rescue t_int
        ret[:day][:labels].push(t_int) unless ret[:day][:labels].include? t_int
        ret[:day][:data][key] ||= {}
        ret[:day][:data][key][:social] = data
        data.map { |k, v| ret[:day][:data][key][:social][k] += v }

      else
        # raise data.inspect
        ret[:day][:data][t_int][:social] ||= {}
        data.map { |k, v| ret[:day][:data][t_int][:social][k] += v }
      end
    end
    ret
    # end
  end

  def news_link
    "/news/#{short_name}"
  end

  def social_link
    "/social/#{short_name}"
  end

  def reddit_link
    "/reddit/#{short_name}"
  end

  def twitter_link
    "/twitter/#{short_name}"
  end

  def recent_notifications
    notifications.last(25)
  end
end
