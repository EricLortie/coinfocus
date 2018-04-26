module WorkerModule
  extend ActionView::Helpers::NumberHelper
  include ApplicationHelper

  def self.build_recent_data
    capture_twitter_stream_data(true)
    capture_subreddit_data(true)

    coins = Coin.first(5)
    coins.each do |coin|
      price_data = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{coin['short_name']}&tsyms=USD")))
      price_data = price_data["RAW"][coin["short_name"]]["USD"] rescue []
      next if price_data.blank?
      price = price_data["PRICE"].to_f rescue 0
      next if price == 0

      capture_snapshot(coin.id, price_data, Time.now.utc, price)
    end
  end

  def self.capture_snapshot(coin_id, price_data, time, price)
    coin = Coin.find(coin_id)
    circulating = coin.circulating || 0
    market_cap = number_with_precision(circulating * price, :precision => 2)
    type = price_data["TYPE"]
    market = price_data["MARKET"]
    fromsymbol = price_data["FROMSYMBOL"]
    tosymbol = price_data["TOSYMBOL"]
    last_volume = price_data["LASTVOLUME"]
    last_volume_to = price_data["LASTVOUMETO"]
    volume_24 = price_data["VOLUME24HOUR"]
    volume_24_to = price_data["VOLUME24HOURTO"]
    open_24 = price_data["OPEN24HOUR"]
    high_24 = price_data["HIGH24HOUR"]
    low_24 = price_data["LOW24HOUR"]
    price_change_30m = coin.price_change(40.minutes.ago.utc, false)
    price_change_pct_30m = coin.price_change(40.minutes.ago.utc, true)
    price_change_60m = coin.price_change(70.minutes.ago.utc, false)
    price_change_pct_60m = coin.price_change(70.minutes.ago.utc, true)
    price_change_24 = coin.price_change(1.day.ago.utc, false, price_data["CHANGE24HOUR"])
    price_change_pct_24 = coin.price_change(1.day.ago.utc, true, price_data["CHANGEPCT24HOUR"])
    price_change_1_week = coin.price_change(1.week.ago.utc, false)
    price_change_pct_1_week = coin.price_change(1.week.ago.utc, true)
    price_change_1_month = coin.price_change(1.month.ago.utc, false)
    price_change_pct_1_month = coin.price_change(1.month.ago.utc, true)
    mc_change_30m = coin.mc_change(30.minutes.ago.utc, false)
    mc_change_pct_30m = coin.mc_change(30.minutes.ago.utc, true)
    mc_change_60m = coin.mc_change(60.minutes.ago.utc, false)
    mc_change_pct_60m = coin.mc_change(60.minutes.ago.utc, true)
    mc_change_24 = coin.mc_change(1.day.ago.utc, false)
    mc_change_pct_24 = coin.mc_change(1.day.ago.utc, true)
    mc_change_1_week = coin.mc_change(1.week.ago.utc, false)
    mc_change_pct_1_week = coin.mc_change(1.week.ago.utc, true)
    mc_change_1_month = coin.mc_change(1.month.ago.utc, false)
    mc_change_pct_1_month = coin.mc_change(1.month.ago.utc, true)
    vol_change_30m = coin.vol_change(30.minutes.ago.utc, false)
    vol_change_pct_30m = coin.vol_change(30.minutes.ago.utc, true)
    vol_change_60m = coin.vol_change(60.minutes.ago.utc, false)
    vol_change_pct_60m = coin.vol_change(60.minutes.ago.utc, true)
    vol_change_24 = coin.vol_change(1.day.ago.utc, false)
    vol_change_pct_24 = coin.vol_change(1.day.ago.utc, true)
    vol_change_1_week = coin.vol_change(1.week.ago.utc, false)
    vol_change_pct_1_week = coin.vol_change(1.week.ago.utc, true)
    vol_change_1_month = coin.vol_change(1.month.ago.utc, false)
    vol_change_pct_1_month = coin.vol_change(1.month.ago.utc, true)

    snapshot = Snapshot.create!(
      :coin_id => coin.id,
      :price => price,
      :coin_type => type,
      :market_cap => market_cap,
      :market => market,
      :fromsymbol => fromsymbol,
      :tosymbol => tosymbol,
      :last_volume => last_volume,
      :last_volume_to => last_volume_to,
      :circulating => circulating,
      :volume_24 => volume_24,
      :volume_24_to => volume_24_to,
      :open_24 => open_24,
      :high_24 => high_24,
      :low_24 => low_24,
      :price_change_30m => price_change_30m,
      :price_change_pct_30m => price_change_pct_30m,
      :price_change_60m => price_change_60m,
      :price_change_pct_60m => price_change_pct_60m,
      :price_change_24 => price_change_24,
      :price_change_pct_24 => price_change_pct_24,
      :price_change_1_week => price_change_1_week,
      :price_change_pct_1_week => price_change_pct_1_week,
      :price_change_1_month => price_change_1_month,
      :price_change_pct_1_month => price_change_pct_1_month,
      :mc_change_30m => mc_change_30m,
      :mc_change_pct_30m => mc_change_pct_30m,
      :mc_change_60m => mc_change_60m,
      :mc_change_pct_60m => mc_change_pct_60m,
      :mc_change_24 => mc_change_24,
      :mc_change_pct_24 => mc_change_pct_24,
      :mc_change_1_week => mc_change_1_week,
      :mc_change_pct_1_week => mc_change_pct_1_week,
      :mc_change_1_month => mc_change_1_month,
      :mc_change_pct_1_month => mc_change_pct_1_month,
      :vol_change_30m => vol_change_30m,
      :vol_change_pct_30m => vol_change_pct_30m,
      :vol_change_60m => vol_change_60m,
      :vol_change_pct_60m => vol_change_pct_60m,
      :vol_change_24 => vol_change_24,
      :vol_change_pct_24 => vol_change_pct_24,
      :vol_change_1_week => vol_change_1_week,
      :vol_change_pct_1_week => vol_change_pct_1_week,
      :vol_change_1_month => vol_change_1_month,
      :vol_change_pct_1_month => vol_change_pct_1_month,
      :time_collected => time
    )

    coin.update(:latest_market_cap => market_cap, :latest_price => price, :last_volume => volume_24_to)

    # SocialMetricWorker.perform_async(snapshot.id)
    capture_snapshot_social_data(snapshot)
  end

  def self.capture_snapshot_social_data(snapshot)
    snapshot = Snapshot.find(snapshot.to_i) unless snapshot.is_a?(Snapshot)

    reddit_15m = reddit_15m_sentiment = reddit_30m = reddit_30m_sentiment = 0
    reddit_60m = reddit_60m_sentiment = reddit_24h = reddit_24h_sentiment = 0
    twitter_15m = twitter_15m_sentiment = twitter_30m = twitter_30m_sentiment = 0
    twitter_60m = twitter_60m_sentiment = twitter_24h = twitter_24h_sentiment = 0
    news_15m = news_15m_sentiment = news_30m = news_30m_sentiment = 0
    news_60m = news_60m_sentiment = news_24h = news_24h_sentiment = 0

    coin = snapshot.coin
    histories = SocialHistory.where("coin_id = ? AND time > ?", coin.id, 24.hours.ago.to_i)
    histories.each do |h|
      time = Time.at(h.time).utc
      if time > 1.day.ago.utc
        reddit_24h += h.reddit_count
        reddit_24h_sentiment += h.reddit_sentiment.to_f
        news_24h += h.news_count
        news_24h_sentiment += h.news_sentiment.to_f
        twitter_24h += h.twitter_count
        twitter_24h_sentiment += h.twitter_sentiment.to_f
      end
      if time > 60.minutes.ago.utc
        reddit_60m += h.reddit_count
        reddit_60m_sentiment += h.reddit_sentiment.to_f
        news_60m += h.news_count
        news_60m_sentiment += h.news_sentiment.to_f
        twitter_60m += h.twitter_count
        twitter_60m_sentiment += h.twitter_sentiment.to_f
      end

      if time > 30.minutes.ago.utc
        reddit_30m += h.reddit_count
        reddit_30m_sentiment += h.reddit_sentiment.to_f
        news_30m += h.news_count
        news_30m_sentiment += h.news_sentiment.to_f
        twitter_30m += h.twitter_count
        twitter_30m_sentiment += h.twitter_sentiment.to_f
      end

      next unless time > 15.minutes.ago.utc
      reddit_15m += h.reddit_count
      reddit_15m_sentiment += h.reddit_sentiment.to_f
      news_15m += h.news_count
      news_15m_sentiment += h.news_sentiment.to_f
      twitter_15m += h.twitter_count
      twitter_15m_sentiment += h.twitter_sentiment.to_f
    end

    previous_snapshot = coin.previous_snapshot
    trending_up = previous_snapshot.price <= snapshot.price
    direction_change = previous_snapshot.trending_up != trending_up
    trending_since = direction_change ? snapshot.created_at : previous_snapshot.trending_since

    # social_chart_data = coin.social_chart_data
    # coin_chart_data = coin.coin_chart_data
    keyword_data = {} # coin.keyword_data

    coin_chart_data = coin.chart_data

    snapshot.update(
      :reddit_15m => reddit_15m,
      :reddit_15m_sentiment => (reddit_15m_sentiment / reddit_15m * 100 rescue 0),
      :reddit_30m => reddit_30m,
      :reddit_30m_sentiment => (reddit_30m_sentiment / reddit_30m * 100 rescue 0),
      :reddit_60m => reddit_60m,
      :reddit_60m_sentiment => (reddit_60m_sentiment / reddit_60m * 100 rescue 0),
      :reddit_24h => reddit_24h,
      :reddit_24h_sentiment => (reddit_24h_sentiment / reddit_24h * 100 rescue 0),
      :twitter_15m => twitter_15m,
      :twitter_15m_sentiment => (twitter_15m_sentiment / twitter_15m * 100 rescue 0),
      :twitter_30m => twitter_30m,
      :twitter_30m_sentiment => (twitter_30m_sentiment / twitter_30m * 100 rescue 0),
      :twitter_60m => twitter_60m,
      :twitter_60m_sentiment => (twitter_60m_sentiment / twitter_60m * 100 rescue 0),
      :twitter_24h => twitter_24h,
      :twitter_24h_sentiment => (twitter_24h_sentiment / twitter_24h * 100 rescue 0),
      :news_15m => news_15m,
      :news_15m_sentiment => (news_15m_sentiment / news_15m * 100 rescue 0),
      :news_30m => news_30m,
      :news_30m_sentiment => (news_30m_sentiment / news_30m * 100 rescue 0),
      :news_60m => news_60m,
      :news_60m_sentiment => (news_60m_sentiment / news_60m * 100 rescue 0),
      :news_24h => news_24h,
      :news_24h_sentiment => (news_24h_sentiment / news_24h * 100 rescue 0),
      :trending_up => trending_up,
      :trending_since => trending_since,
      :keyword_data => keyword_data,
      :daily_chart_data => coin_chart_data[:day],
      :weekly_chart_data => coin_chart_data[:week],
      :monthly_chart_data => coin_chart_data[:month],
      :yearly_chart_data => coin_chart_data[:year],
      :complete => true
    )

    # :daily_social_data => social_chart_data[:day],
    # :weekly_social_data => social_chart_data[:week],
    # :monthly_social_data => social_chart_data[:month],
    # :yearly_social_data => social_chart_data[:year],

    coin.update(:latest_snapshot_id => snapshot.id)

    # notif = coin.notifications.create!(
    #   :n_type => "snapshot",
    #   :title => "New data for #{coin.full_name} (#{coin.short_name})",
    #   :body => "",
    #   :global => false
    # )
    # WorkerModule.send_notification(:notif => notif, :n_type => "snapshot", :coin_links => ["/crypto/#{coin.short_name}"], :coin_ids => [coin.short_name])

    WorkerModule.build_history(coin)

    # Rails.env.development? ? calculate_averages(snapshot) : AverageCalculationWorker.perform_async(snapshot.id)

    WorkerModule.preheat_cache_for(coin.id, coin.short_name) if Rails.env != "development" and coin.id < 2020
  end

  def self.build_history(coin)
    [(5 * 60), (60 * 60), (60 * 60 * 24)].each do |t|
      h = History.find_or_create_by!(
        :coin_id => coin.id,
        :time => Time.now.utc.round_off(t),
        :symbolfrom => coin.short_name,
        :symbolto => "USD",
        :length => t
      )

      props = {}
      props[:high] = coin.latest_price if h.high.blank? or coin.latest_price > h.high
      props[:low] = coin.latest_price if h.low.blank? or coin.latest_price < h.low
      props[:close] = coin.latest_price
      h.update(props)
    end
  end

  def self.calculate_averages(snapshot)
    snapshot = Snapshot.find(snapshot) unless snapshot.is_a? Snapshot
    return if snapshot.blank? or rand(10) > 5
    # keys = Snapshot.column_names.reject { |c| %w[id daily_chart_data weekly_chart_data monthly_chart_data yearly_chart_data keyword_data coin_id market fromsymbol tosymbol coin_type created_at updated_at trending_up daily_social_data weekly_social_data monthly_social_data yearly_social_data complete].include? c }
    keys = %w[price market_cap reddit_30m twitter_30m news_30m reddit_60m twitter_60m news_60m volume_24]
    keys.each do |k|
      time_periods = ["1 hour", "6 hours"]
      time_periods.each do |t|
        case t
        when "1 hour"
          date = Time.now.utc.change(:min => 0).to_i
          length = (60 * 60)
        when "6 hours"
          date = Time.now.utc.change(:hour => (Time.now.utc.hour - (Time.now.utc.hour % 6))).to_i
          length = (6 * 60 * 60)
        when "1 day"
          date = Time.now.utc.change(:hour => 0, :min => 0).to_i
          length = (24 * 60 * 60)
        when "1 week"
          date = Time.now.utc.at_beginning_of_week.to_i
          length = (7 * 24 * 60 * 60)
        end

        begin
          average = Average.find_or_create_by!(:coin_id => snapshot.coin.id, :avg_key => k, :time => date, :length => length)
          average["count"] += 1
          average["total"] = average["total"].to_f + snapshot[k] rescue 0
          average["average"] = average["total"].to_f / average["count"] rescue 0
          average.save
        rescue ActiveRecord::RecordNotUnique
          average = Average.find_by(:coin_id => snapshot.coin.id, :avg_key => k, :time => date, :length => length)
          next if average.blank?
          average["count"] += 1
          average["total"] = average["total"].to_f + snapshot[k] rescue 0
          average["average"] = average["total"].to_f / average["count"] rescue 0
          average.save
          Rails.logger.debug("RECORD NOT UNIQUE FOR AVERAGE")
        end
      end
    end
  end

  def self.build_snapshot_monitor
    @coins = Coin.joins("JOIN snapshots ON snapshots.coin_id = coins.id WHERE coins.latest_snapshot_id = snapshots.id AND snapshots.complete IS NOT NULL")
                 .select("coins.*, #{Snapshot.column_names.map { |c| "snapshots.#{c} as snapshot_#{c}" }.join(', ')}")
                 .order("coins.latest_market_cap DESC")
    params = {}
    @coins.first(300) do |coin|
      next if coin.snapshot_updated_at.utc < 10.minutes.ago.utc
      if params[:highest_price].blank? or coin.latest_price > params[:highest_price]
        params[:highest_price] = coin.latest_price
        params[:highest_price_id] = coin.id
      end
      if params[:highest_market_cap].blank? or coin.latest_market_cap > params[:highest_market_cap]
        params[:highest_market_cap] = coin.latest_price
        params[:highest_market_cap_id] = coin.id
      end
      if params[:highest_volume].blank? or coin.latest_market_cap > params[:highest_volume]
        params[:highest_volume] = coin.latest_price
        params[:highest_volume_id] = coin.id
      end
      if params[:highest_circulating].blank? or (coin.circulating.present? and coin.circulating > params[:highest_circulating])
        params[:highest_circulating] = coin.circulating
        params[:highest_circulating_id] = coin.id
      end
    end

    SnapshotMonitor.create!(params)
  end

  def self.send_notification(params)
    params[:created_at] = params[:notif].created_at.utc
    ActionCable.server.broadcast "notifications_channel", params
  end

  def self.test_notifications
    notif = Notification.create!(
      :n_type => "global",
      :title => "Test GLOBAL notification!",
      :global => true,
      :test => true
    )

    WorkerModule.send_notification(:notif => notif, :n_type => "global")
  end

  def self.test_coin_notifications
    notif = Notification.create!(
      :n_type => "snapshot",
      :title => "Test BTC notification!",
      :global => false,
      :test => true
    )
    CoinNotification.create!(:coin_id => 2003, :notification_id => notif.id)
    notif_urls = ["/crypto/BTC"]
    coin_ids = ["BTC"]

    WorkerModule.send_notification(:notif => notif, :n_type => "snapshot", :coin_links => notif_urls, :coin_ids => coin_ids)
  end

  def self.preheat_cache_for(coin_id, short_name)
    Rails.cache.delete("coin_index #{coin_id}")
    url = Rails.env.development? ? "localhost" : "https://www.coinfocus.io"
    `curl '#{url}/single_coin_row/#{coin_id}'`
    Rails.cache.delete("coin_show #{coin_id}")
    `curl '#{url}/crypto/#{short_name}'`
  end

  def self.capture_circulating(coin_external_id)
    market_data = JSON.parse(Net::HTTP.get(URI.parse("https://www.cryptocompare.com/api/data/coinsnapshotfullbyid/?id=#{coin_external_id}")))
    circulating = market_data["Data"]["General"]["TotalCoinsMined"].to_i
    Coin.find_by(:external_id => coin_external_id).update(:circulating => circulating)
  end

  def self.capture_twitter_stream_data(testing=false)
    SystemVariable.first.update_attributes(:twitter_stream_active => 1)
    twitter = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
      config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
    end

    topics = %w[Bitcoin Cryptocurrency Blockchain Crypto hodl]
    count = 0
    twitter.filter(:track => topics.join(",")) do |tweet|
      break if count > 300 or (testing and count > 20)
      begin
        tweet = tweet.to_h
        next if tweet[:text].blank? or tweet[:user].blank? or tweet[:user][:friends_count] < 300

        # tweet = tweet.symbolize_keys
        coins = fetch_cached_coin_list(:levels => 10)
        coins = coins.flatten.first if coins.is_a?(Array)
        keys = tweet[:text].scan(fetch_cached_rx_string).flatten.uniq
        keys = keys.reject { |k| coins[k].blank? }.uniq
        next if keys.blank?
        # next unless WorkerModule.secondary_regex_match(tweet[:text])

        social = {}
        social[:comments] = tweet[:reply_count]
        social[:likes] = tweet[:favorite_count]
        social[:shares] = tweet[:retweet_count]

        tweeter = tweet[:user].symbolize_keys

        posted_at = Time.parse(tweet[:created_at]).utc

        tweet_url = "https://twitter.com/#{tweeter[:screen_name]}/status/#{tweet[:id]}"

        creator = Creator.find_or_create_by!(:name => tweeter[:screen_name], :foreign_id => tweeter[:id_str], :creator_type => "twitter", :url => "http://twitter.com/#{tweeter[:screen_name]}")

        social_mention = SocialMention.create!(
          :creator_id => creator.id,
          :social_id => tweet[:id],
          :social_title => tweet[:text],
          :social_body => "",
          :social_type => "twitter",
          :url => tweet_url,
          :posted_at => posted_at
        )
        count += 1
        capture_tweet_data(social_mention.id, social, keys, tweet_url, posted_at)
      rescue ActiveRecord::RecordNotUnique
        next
      rescue ActiveRecord::RecordInvalid
        next
      end
    end
    SystemVariable.first.update_attributes(:twitter_stream_active => 0)
  rescue EOFError, JSON::ParserError
    SystemVariable.first.update_attributes(:twitter_stream_active => 0)
  end

  def self.capture_tweet_data(id, social, keys, tweet_url, posted_at)
    social_mention = SocialMention.find(id)
    score = SocialScore.calculate_score(social)

    SocialScore.create!(:social_mention_id => social_mention.id, :likes => social[:likes], :shares => social[:shares], :comments => social[:comments], :score => score)

    keyword_ids = keyword_analysis(social_mention.id, social_mention.social_title) if score >= 5

    coins = fetch_cached_coin_list(:levels => 10)
    coins = coins.flatten.first if coins.is_a?(Array)

    coin_ids = []
    keys.each do |k|
      coin_id = coins[k].to_i rescue ""
      next if coin_id.blank? or coin_ids.include?(coin_id)
      coin_ids.push(coin_id)
      CoinSocialMention.create!(
        :coin_id => coin_id,
        :social_mention_id => social_mention.id
      )

      if Rails.env.development?
        build_social_history(coin_id, "twitter", social_mention.sentiment, tweet_url)
      else
        SocialHistoryWorker.set(:queue => "critical").perform_async(coin_id, "twitter", social_mention.sentiment, tweet_url)
      end

      next if keyword_ids.blank?
      keyword_ids.each do |kword|
        CoinKeyword.create!(:keyword_id => kword, :coin_id => coin_id, :posted_at => posted_at)
      end
    end

    social_mention.update(:latest_score => score, :coin_short_names => social_mention.coins.collect(&:short_name))
  end

  def self.capture_reddit_post_stream_data
    SystemVariable.first.update_attributes(:reddit_post_stream_active => 1)
    # last_result = SocialMention.latest_reddit

    session = Redd.it(
      :user_agent => "CoinFocus App:v1.0.0 (by /u/Elortee)",
      :client_id => ENV["REDDIT_CLIENT_ID"],
      :secret => ENV["REDDIT_SECRET"],
      :username => ENV["REDDIT_USERNAME"],
      :password => ENV["REDDIT_PASSWORD"]
    )

    count = 0
    session.subreddit("all").post_stream do |c|
      begin
        break if count > 50
        process_reddit(c)
        count += 1
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end
    SystemVariable.first.update_attributes(:reddit_post_stream_active => 0)
  rescue Redd::InvalidAccess
    SystemVariable.first.update_attributes(:reddit_post_stream_active => 0)
  end

  def self.capture_reddit_comment_stream_data
    SystemVariable.first.update_attributes(:reddit_comment_stream_active => 1)
    # last_result = SocialMention.latest_reddit

    session = Redd.it(
      :user_agent => "CoinFocus App:v1.0.0 (by /u/Elortee)",
      :client_id => ENV["REDDIT_CLIENT_ID"],
      :secret => ENV["REDDIT_SECRET"],
      :username => ENV["REDDIT_USERNAME"],
      :password => ENV["REDDIT_PASSWORD"]
    )

    count = 0
    session.subreddit("all").comment_stream do |c|
      begin
        break if count > 50
        process_reddit(c)
        count += 1
      rescue ActiveRecord::RecordNotUnique
        next
      end
    end
    SystemVariable.first.update_attributes(:reddit_comment_stream_active => 0)
    # rescue StandardError
    #   SystemVariable.first.update_attributes(:reddit_comment_stream_active => 0)
  end

  def self.capture_subreddit_data(testing=false)
    SystemVariable.first.update_attributes(:reddit_subreddit_worker_active => 1)
    last_result_id = SocialMention.latest_reddit.social_id rescue "0"

    session = Redd.it(
      :user_agent => "CoinFocus App:v1.0.0 (by /u/Elortee)",
      :client_id => ENV["REDDIT_CLIENT_ID"],
      :secret => ENV["REDDIT_SECRET"],
      :username => ENV["REDDIT_USERNAME"],
      :password => ENV["REDDIT_PASSWORD"]
    )

    count = 0
    if !testing
      srs = session.my_subreddits("subscriber", :limit => 100)
      subreddits = srs.collect { |s| s.display_name_prefixed.gsub("r/", "") }
    else
      subreddits = ["Bitcoin"]
    end
    subreddits.each do |sr|
      session.subreddit(sr).comments(:before => last_result_id).each do |c|
        begin
          break if count > 20 and testing
          process_reddit(c)
          count += 1
        rescue ActiveRecord::RecordNotUnique
          next
        end
      end
    end
    SystemVariable.first.update_attributes(:reddit_subreddit_worker_active => 0)
    # rescue StandardError
    #   SystemVariable.first.update_attributes(:reddit_subreddit_worker_active => 0)
  end

  def self.process_reddit(c)
    c = c.to_h rescue ""
    return if c.blank?

    created_utc = c[:created_utc] rescue ""
    title = c[:title] rescue ""
    body = c[:body] rescue ""
    return if (body.blank? and title.blank?) or created_utc.blank?
    coins = fetch_cached_coin_list(:levels => 5)
    coins = coins.flatten.first if coins.is_a?(Array)
    keys = "#{title} #{body}".scan(fetch_cached_rx_string).flatten.uniq
    keys = keys.reject { |k| coins[k].blank? }.uniq
    return if keys.blank?
    return unless WorkerModule.secondary_regex_match("#{title} #{body}")
    begin
      social = {}
      social[:comments] = c[:num_comments] if c[:num_comments].present?
      ups = c[:ups].presence || 0
      downs = c[:downs].presence || 0
      social[:likes] = ups - downs
      social[:shares] = (c[:gilded] * 250) if c[:gilded].present?

      posted_at = Time.at(created_utc).utc rescue Time.now.utc
      creator = Creator.find_or_create_by!(:name => c[:author].name, :foreign_id => c[:author].id, :creator_type => "reddit", :url => "http://reddit.com/u/#{c[:author].id}")

      social_mention = SocialMention.create!(
        :social_id => c[:id],
        :social_title => title,
        :social_body => body,
        :creator_id => creator.id,
        :social_type => "reddit",
        :url => c[:permalink],
        :posted_at => posted_at
      )

      capture_reddit_post_data(social_mention.id, social, keys, c[:url], posted_at)
    rescue ActiveRecord::RecordInvalid
      return
    rescue Redd::NotFound
      return
    end
  end

  def self.capture_reddit_post_data(id, social, keys, url, posted_at)
    social_mention = SocialMention.find(id) rescue ""
    return if social_mention.blank?
    begin
      score = SocialScore.calculate_score(social)

      SocialScore.create!(:social_mention_id => social_mention.id, :likes => social[:likes], :shares => social[:shares], :comments => social[:comments], :score => score)

      keyword_ids = keyword_analysis(social_mention.id, social_mention.social_body) if score >= 5

      coins = fetch_cached_coin_list(:levels => 10)
      coins = coins.flatten.first if coins.is_a?(Array)

      coin_ids = []
      keys.each do |k|
        coin_id = coins[k].to_i rescue ""
        next if coin_id.blank? or coin_ids.include?(coin_id)
        CoinSocialMention.create!(
          :coin_id => coin_id,
          :social_mention_id => social_mention.id
        )

        if Rails.env.development?
          build_social_history(coin_id, "reddit", social_mention.sentiment, url)
        else
          SocialHistoryWorker.set(:queue => "critical").perform_async(coin_id, "reddit", social_mention.sentiment, url)
        end

        next if keyword_ids.blank?
        keyword_ids.each do |kword|
          CoinKeyword.create!(:keyword_id => kword, :coin_id => coin_id, :posted_at => posted_at)
        end
      end

      social_mention.update(:latest_score => score, :coin_short_names => social_mention.coins.collect(&:short_name))
    rescue ActiveRecord::RecordNotUnique
      return
    end
  end

  def self.keyword_analysis(sm_id, message)
    require "aylien_text_api"

    textapi = AylienTextApi::Client.new(:app_id => ENV["AYLIEN_APP_ID"], :app_key => ENV["AYLIEN_KEY"])
    sentiment = textapi.sentiment :text => message
    entities = textapi.entities :text => message

    sentiment_score = (sentiment[:polarity_confidence] * (sentiment[:polarity] == "positive" ? 1 : -1) rescue 0)
    SocialMention.find(sm_id).update!(:sentiment => sentiment_score)

    keyword_ids = []
    entities = entities[:entities] rescue {}
    [entities[:keyword], entities[:organization], entities[:person], entities[:location]].flatten.each do |k|
      keyword = Keyword.find_or_create_by!(:keyword => k)
      keyword.save!
      keyword_ids.push(keyword.id)
    end

    keyword_ids.uniq
  end

  def self.build_histories
    Coin.all.each do |c|
      if c.histories.blank?

        history = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/histoday?fsym=#{c[:short_name]}&tsym=USD&limit=3000&allData=true")))

        history["Data"].each do |h|
          History.create(:time => h["time"], :coin_id => coin_id, :close => h["close"], :high => h["high"], :low => h["low"], :volumeto => h["volumeto"], :volumefrom => h["volumefrom"], :symbolfrom => c[:short_name], :symbolto => "USD")
        end
      else
        (Time.at(c.histories.first.time).utc.strftime("%F")..Time.now.utc.strftime("%F")).each do |d|
          day = Time.parse(d).utc rescue false
          next unless day
          next if Time.now.utc.beginning_of_day == Time.parse(d).utc.beginning_of_day
          high = 0
          low = 1_000_000
          snapshots = c.snapshots.where("created_at BETWEEN ? AND ?", Time.parse(d).utc.beginning_of_day, Time.parse(d).utc.end_of_day)
          next if snapshots.blank?
          snapshots.each do |s|
            high = s.price if s.price > high
            low = s.price if s.price < low
          end
          close = snapshots.last.price
          volumefrom = snapshots.last.volume_24
          volumeto = snapshots.last.last_volume_to
          History.create!(
            :coin_id => c.id,
            :time => day.to_i,
            :symbolfrom => c.short_name,
            :symbolto => "USD",
            :high => high,
            :low => low,
            :close => close,
            :volumefrom => volumefrom,
            :volumeto => volumeto
          )
        end
      end
    end
  end

  def self.start_news_worker(levels=1, search_timeline=timeline)
    require "aylien_news_api"
    coin_list = fetch_cached_coin_list(:levels => levels, :flatten => false)
    # Setup authorization
    AylienNewsApi.configure do |config|
      # Configure API key authorization: app_id
      config.api_key["X-AYLIEN-NewsAPI-Application-ID"] = ENV["AYLIEN_NEWS_APP_ID"]

      # Configure API key authorization: app_key
      config.api_key["X-AYLIEN-NewsAPI-Application-Key"] = ENV["AYLIEN_NEWS_APP_KEY"]
    end

    # create an instance of the API class
    $api_instance = AylienNewsApi::DefaultApi.new

    coin_list.each_with_index do |coins, i|
      next if coins.blank?
      opts = {
        :title => coins.map { |k, _v| k }.join(" OR "),
        :language => ["en"],
        :published_at_start => "#{search_timeline}",
        :published_at_end => Time.now.utc.strftime("%Y-%m-%dT%TZ"),
        :cursor => "*",
        :per_page => 80,
        :sort_by => "published_at",
        :sort_direction => "desc",
        :level_index => i
      }
      WorkerModule.fetch_new_stories(opts)
    end
  end

  def self.fetch_new_stories(params={})
    # puts "------------"

    fetched_stories = []
    stories = nil

    while stories.nil? || !stories.empty?
      # begin
      result = $api_instance.list_stories(params)
      # rescue AylienNewsApi::ApiError => e
      # if e.code == 429
      # puts 'Usage limit are exceeded. Wating for 60 seconds...'
      # retry
      # raise params.inspect if e.code == 422
      # end

      next if result.blank?
      stories = result.stories
      params[:cursor] = result.next_page_cursor
      fetched_stories += stories
      Rails.logger.debug "Fetched #{stories.size} stories. Total story count so far: #{fetched_stories.size}"

    end

    fetched_stories.each do |s|
      WorkerModule.save_news_story(s)
    end
  end

  def self.secondary_keywords
    %w[market Market exchange Exchange coinbase Coinbase finance Finance Currency currency economy Economy altcoin Altcoin cryptocoin Cryptocoin Crypto crypto Cryptocurrency cryptocurrenct Cryptocurrencies cryptocurrencies Blockchain blockchain bitcoin Bitcoin btc BTC Ethereum ethereum litecoin Litecoin]
  end

  def self.secondary_match(keywords)
    (keywords - secondary_keywords).length < keywords.length
  end

  def self.secondary_regex_match(text)
    !text.scan(/#{secondary_keywords.join("|")}/i).empty?
  end

  def self.save_news_story(s)
    return if SocialMention.find_by(:social_id => s.id, :social_type => "news").present?
    coins = fetch_cached_coin_list(:levels => 5)
    coins = coins.flatten.first if coins.is_a?(Array)

    keywords = [s.entities.title.collect(&:text), s.keywords, s.hashtags].flatten
    return unless WorkerModule.secondary_match(keywords)

    mentioned_coins = keywords.reject { |k| coins[k].blank? }.uniq
    return if mentioned_coins.blank?

    social = {}
    social[:likes] = s.social_shares_count.facebook + s.social_shares_count.linkedin + s.social_shares_count.reddit
    social[:rank] = s.source.rankings.alexa.first.rank rescue 0
    score = SocialScore.calculate_score(social)

    title_score = s.sentiment.title.score * (s.sentiment.title.polarity == "positive" ? 1 : -1)
    body_score = s.sentiment.body.score * (s.sentiment.body.polarity == "positive" ? 1 : -1)

    sentiment_score = title_score + body_score

    creator = Creator.find_or_create_by!(:name => s.source.name, :foreign_id => s.source.id, :creator_type => "news")
    creator.update_attributes(:url => (s.source.home_page_url rescue "N/A")) if creator.url.blank?
    creator.update_attributes(:description => (s.source.description rescue "N/A")) if creator.description.blank?

    social_mention = SocialMention.create!(
      :social_id => s.id,
      :social_title => (s.title rescue ""),
      :social_body => (s.body rescue ""),
      :creator_id => creator.id,
      :social_type => "news",
      :url => (s.links.permalink rescue "N/A"),
      :posted_at => s.published_at.utc,
      :latest_score => score,
      :sentiment => sentiment_score
    ) rescue "DUPLICATE"
    return if social_mention == "DUPLICATE"
    SocialScore.create!(:social_mention_id => social_mention.id, :likes => social[:likes], :shares => social[:shares], :comments => social[:comments], :score => score)

    keyword_ids = []
    keywords.each do |k|
      keyword = Keyword.find_or_create_by!(:keyword => k)
      keyword.save!
      keyword_ids.push(keyword.id)
    end

    notif_urls = []
    coin_ids = []
    notif_ids = []

    mentioned_coins.each do |k|
      coin_id = coins[k].to_i rescue ""
      next if coin_id.blank? or coin_id == 0 or notif_ids.include?(coin_id)
      CoinSocialMention.create!(
        :coin_id => coin_id,
        :social_mention_id => social_mention.id
      )

      notif_urls.push("/crypto/#{k}")
      coin_ids.push(k)
      notif_ids.push(coin_id)

      next if keyword_ids.blank?
      keyword_ids.each do |kword|
        CoinKeyword.create!(:keyword_id => kword, :coin_id => coin_id, :posted_at => s.published_at.utc)
      end
    end

    notif = Notification.create!(
      :n_type => "news",
      :title => "New story about #{coin_ids.join(', ')}",
      :body => "#{s.source.name} - #{s.title}",
      :global => true
    )

    notif_ids.each do |n|
      if Rails.env.development?
        build_social_history(n, "news", sentiment_score, s.links.permalink)
      else
        SocialHistoryWorker.set(:queue => "critical").perform_async(n, "news", sentiment_score, s.links.permalink)
      end
      CoinNotification.create!(:coin_id => n, :notification_id => notif.id)
    end

    social_mention.update(:coin_short_names => social_mention.coins.collect(&:short_name))

    WorkerModule.send_notification(:notif => notif, :n_type => "global", :coin_links => notif_urls, :coin_ids => coin_ids) if notif.present?
  end

  def self.build_social_history(coin_id, s_type, sentiment, url)
    h = SocialHistory.find_or_create_by!(
      :coin_id => coin_id,
      :time => Time.now.utc.round_off(5 * 60)
    )
    props = {}
    if s_type == "reddit"
      props[:reddit_count] = h[:reddit_count] + 1
      props[:reddit_sentiment] = h[:reddit_sentiment].to_f + sentiment.to_f
    elsif s_type == "twitter"
      props[:twitter_count] = h[:twitter_count] + 1
      props[:twitter_sentiment] = h[:twitter_sentiment].to_f + sentiment.to_f
    else
      props[:news_count] = h[:news_count] + 1
      props[:news_sentiment] = h[:news_sentiment].to_f + sentiment.to_f
    end
    if s_type == "news"
      props[:urls] = h[:urls].blank? ? url : "#{h[:urls]}, #{url}"
    end
    props[:length] = (5 * 60)
    h.update(props)
  end

  def self.fetch_cached_rx_string
    Rails.cache.fetch("rx_string #{ENV['HEROKU_RELEASE_VERSION']} #{Time.now.utc.at_beginning_of_minute.to_i if Rails.env.development?}", :expires_in => 6.hours) do
      coins_array = []
      Coin.all.map do |c|
        coins_array.push(c.short_name)
        coins_array.push(c.full_name)
      end
      /(?<!\w)(?:#*)(#{coins_array.join('|')})(?!\w)/i
    end
  end

  def self.fetch_cached_coin_list(opts)
    opts[:levels] = 1 if opts[:levels].blank?
    opts[:flatten] = true if opts[:levels].blank?
    Rails.cache.fetch("coin_list #{opts[:levels]} #{opts[:flatten]} #{ENV['HEROKU_RELEASE_VERSION']}", :expires_in => 12.hours) do
      coins_array = []
      # final_array = []
      count = 1
      index = 0
      Coin.all.map do |c|
        coins_array[index] ||= {}
        coins_array[index][c.short_name] = c.id
        coins_array[index][c.short_name.downcase] = c.id
        # coins_array[index]["##{c.short_name.downcase}"] = c.id
        coins_array[index][c.full_name] = c.id
        coins_array[index][c.full_name.downcase] = c.id
        # coins_array[index]["##{c.full_name.downcase}"] = c.id
        index += 1 if count % 30 == 0
        count += 1
      end
      # coins_array.each_with_index do |c, i|
      #   final_array[i] = c if i <= opts[:levels]
      # end
      coins_array = coins_array[0, opts[:levels]]
      ret = opts[:flatten] ? coins_array.compact.reduce({}, :merge) : coins_array
      ret
    end
  end
end
