class CoinsController < ApplicationController
  respond_to :html, :js
  # before_action :authenticate_user!
  helper ApplicationHelper

  # caches_action :index, :cache_path => proc { |c| c.params }, :expires => 10.minutes

  def index
    if current_user&.admin?
      @coins = Coin.joins("JOIN snapshots ON snapshots.coin_id = coins.id WHERE coins.latest_snapshot_id = snapshots.id")
                   .select("coins.*, #{Snapshot.column_names.map { |c| "snapshots.#{c} as snapshot_#{c}" }.join(', ')}")
                   .order("coins.latest_market_cap DESC")
                   .paginate(:page => params[:page], :per_page => 10)

    else
      count = current_user ? current_user.role_coin_count : 10
      @coins = Coin.joins("JOIN snapshots ON snapshots.coin_id = coins.id WHERE coins.latest_snapshot_id = snapshots.id")
                   .select("coins.*, #{Snapshot.column_names.map { |c| "snapshots.#{c} as snapshot_#{c}" }.join(', ')}")
                   .order("coins.latest_market_cap DESC")
                   .paginate(:page => params[:page], :per_page => 10, :total_entries => count)
    end

    @meta_title = meta_title "Cryptocurrency Tracking & Predictions"
    @meta_description = "Detailed Data Analysis on Hundreds of Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def show
    @coin = Coin.find_by("coins.short_name = '#{params[:coin]}'")
    @snapshot = Snapshot.find_by(:id => @coin.latest_snapshot_id)

    @meta_title = meta_title "#{@coin.full_name} (#{@coin.short_name})"
    @meta_description = "Detailed Data Analysis, news and social media stats for #{@coin.full_name}"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }

    @coin_news = SocialMention.joins(:creator).joins(:coins)
                              .select(@sm_join)
                              .where("social_type = ? AND coins.id = ? AND posted_at < ?", "news", @coin.id, SocialMention.social_mention_limit("news", current_user))
                              .order("social_mentions.created_at DESC").limit(25)

    @coin_social_mentions = SocialMention.joins(:creator)
                                         .joins(:coins)
                                         .select(@sm_join)
                                         .where("social_type != ? AND coins.id = ? AND posted_at < ?", "news", @coin.id, SocialMention.social_mention_limit("social_mention", current_user))
                                         .order("social_mentions.created_at DESC").limit(100)
  end

  def show_coin_from_prod
    # @coin = OpenStruct.new(JSON.parse(ProductionCoin.production_data_for(params[:id].to_i).to_json).first)
    # # raise @coin.snapshot_id.inspect
    #
    # @meta_title = meta_title "#{@coin.full_name} (#{@coin.short_name})"
    # @meta_description = "Detailed Data Analysis, news and social media stats for #{@coin.full_name}"
    # @og_properties = {
    #   :title => @meta_title,
    #   :type => "website",
    #   :image => view_context.image_url("logo.png"), # this file should exist in /app/assets/images/logo.png
    # }
    #
    # @coin_news = SocialMention.joins(:creator).joins(:coins)
    #                           .select(@sm_join)
    #                           .where("social_type = ? AND coins.id = ? AND posted_at < ?", "news", @coin.id, SocialMention.social_mention_limit("news", current_user))
    #                           .order("social_mentions.created_at DESC").limit(25)
    #
    # @coin_social_mentions = SocialMention.joins(:creator)
    #                                      .joins(:coins)
    #                                      .select(@sm_join)
    #                                      .where("social_type != ? AND coins.id = ? AND posted_at < ?", "news", @coin.id, SocialMention.social_mention_limit("social_mention", current_user))
    #                                      .order("social_mentions.created_at DESC").limit(100)
    #
    # render :template => "coins/show"
    redirect_to(:action => "index", :controller => "home")
  end

  def single_coin_row
    @coin = Coin.joins("JOIN snapshots ON snapshots.coin_id = coins.id WHERE coins.latest_snapshot_id = snapshots.id AND snapshots.complete IS NOT NULL AND coins.id = #{params[:id]}")
                .select("coins.*, #{Snapshot.column_names.map { |c| "snapshots.#{c} as snapshot_#{c}" }.join(', ')}")
                .order("coins.latest_market_cap DESC").limit(1)

    render :layout => false, :template => "coins/_coin_row", :locals => { :coin => @coin.first }
  end

  def fetch_circulating_values
    count = Rails.env.development? ? 1 : 800
    Coin.first(count).each do |c|
      CoinCirculationWorker.set(:queue => "low_priority").perform_async(c.external_id)
    end
    redirect_to({ :action => "index", :controller => "coins" }, :alert => "Coins queued for update")
  end

  def fetch_coins
    uri = "https://www.cryptocompare.com/api/data/coinlist/"
    coinlist = JSON.parse(Net::HTTP.get(URI.parse(uri)))
    coins = coinlist["Data"]
    count = 0
    coins.each_value do |coin|
      new_coin = false
      flags_changed = false
      db_coin = Coin.where(:short_name => coin["Name"]).first
      if db_coin.blank?
        db_coin = Coin.create(:external_id => coin["Id"], :full_name => coin["CoinName"], :short_name => coin["Name"], :image_url => external_img(coin["ImageUrl"]))
        new_coin = true
      end
      unless db_coin.histories_fetched
        history = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/histoday?fsym=#{coin['Name']}&tsym=USD&limit=3000&allData=true")))

        history["Data"].each do |h|
          HistoryWorker.set(:queue => "low_priority").perform_async(h, db_coin.id, coin["Name"], "USD")
        end
        flags_changed = true
      end

      if new_coin
        [coin["CoinName"], coin["Name"]].each do |k|
          keyword = Keyword.find_or_create_by(:keyword => k)
          keyword.save!
          coin_keyword = CoinKeyword.find_or_create_by(:keyword_id => keyword.id, :coin_id => db_coin.id)
          coin_keyword[:count] = coin_keyword[:count].to_i + 1
          coin_keyword.save!
        end
      end
      db_coin.update(:histories_fetched => true, :default_rss_built => true) if flags_changed
      count += 1
    end

    redirect_to({ :action => "index", :controller => "home" }, :alert => "#{count} coins added.")
  end

  def build_histories
    WorkerModule.build_histories
    redirect_to({ :action => "index", :controller => "home" }, :alert => "Histories built")
  end

  def external_img(url)
    "https://www.cryptocompare.com#{url}"
  end

  def chart
    @coin = Coin.find(params[:coin_id].to_i)
    @chart = params[:chart] || "day"
    show_page = params[:show_page] == "true"

    render :partial => "chart", :locals => { :coin => @coin, :chart => params[:chart], :show_social => show_page, :stackcharts => show_page }, :layout => false
  end
end
