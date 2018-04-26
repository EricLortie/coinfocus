class SocialMentionsController < ApplicationController
  # before_action :authenticate_user!

  def capture_twitter_stream_data
    WorkerModule.capture_twitter_stream_data(true)
    redirect_to({ :action => "twitter", :controller => "social_mentions" }, :alert => "Testing Twitter connection")
  end

  def fetch_reddit_stream
    WorkerModule.capture_reddit_stream_data
  end

  def test_reddit_post_stream
    WorkerModule.capture_reddit_post_stream_data(4.minutes.ago.utc)
    redirect_to({ :action => "reddit", :controller => "social_mentions" }, :alert => "Testing reddit post connection")
  end

  def test_reddit_comment_stream
    WorkerModule.capture_reddit_comment_stream_data(4.minutes.ago.utc)
    redirect_to({ :action => "reddit", :controller => "social_mentions" }, :alert => "Testing reddit comment connection")
  end

  def test_subreddit_worker
    WorkerModule.capture_subreddit_data(true)
    redirect_to({ :action => "reddit", :controller => "social_mentions" }, :alert => "Testing subreddit worker")
  end

  def test_news_stream
    WorkerModule.start_news_worker(1, (Time.now.utc - 1800).strftime("%Y-%m-%dT%TZ"))
    redirect_to({ :action => "news", :controller => "social_mentions" }, :alert => "Testing news stream connection")
  end

  def news
    @coin_social_mentions = SocialMention.joins(:creator)
                                         .select(@sm_join)
                                         .where(:social_type => "news")
                                         .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "News & Articles"
    @meta_description = "Recent News for Top Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def news_for_coin
    @coin = Coin.find_by(:short_name => params[:coin])

    @coin_social_mentions = @coin.social_mentions.joins(:creator)
                                 .select(@sm_join)
                                 .where(:social_type => "news")
                                 .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "News about #{@coin.full_name} (#{@coin.short_name})"
    @meta_description = "Recent News for #{@coin.full_name} (#{@coin.short_name}) gathered from hundreds of different sources."
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def social
    @coin_social_mentions = SocialMention.joins(:creator)
                                         .select(@sm_join)
                                         .where("social_type != ?", "news")
                                         .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "Social Media Content"
    @meta_description = "Recent Mentions & Posts for Top Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def reddit
    @coin_social_mentions = SocialMention.joins(:creator)
                                         .select(@sm_join)
                                         .where(:social_type => "reddit")
                                         .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "Reddit Content"
    @meta_description = "Recent Reddit Posts for Top Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def twitter
    @coin_social_mentions = SocialMention.joins(:creator)
                                         .select(@sm_join)
                                         .where(:social_type => "twitter")
                                         .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "Twitter Content"
    @meta_description = "Recent Tweets about Top Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def social_for_coin
    @coin = Coin.find_by(:short_name => params[:coin])
    @coin_social_mentions = @coin.social_mentions.joins(:creator)
                                 .select(@sm_join)
                                 .where("social_type != ?", "news")
                                 .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "Recent Social Media Mentions of #{@coin.full_name} (#{@coin.short_name})"
    @meta_description = "Posts about #{@coin.full_name} (#{@coin.short_name}) from top social media platforms."
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def reddit_for_coin
    @coin = Coin.find_by(:short_name => params[:coin])
    @coin_social_mentions = @coin.social_mentions.joins(:creator)
                                 .select(@sm_join)
                                 .where(:social_type => "reddit")
                                 .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)
    @meta_title = meta_title "Recent Reddit Mentions of #{@coin.full_name} (#{@coin.short_name})"
    @meta_description = "Reddit posts about #{@coin.full_name} (#{@coin.short_name}) from top social media platforms."
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def twitter_for_coin
    @coin = Coin.find_by(:short_name => params[:coin])
    @coin_social_mentions = @coin.social_mentions.joins(:creator)
                                 .select(@sm_join)
                                 .where(:social_type => "twitter")
                                 .order("created_at DESC").paginate(:page => params[:page], :per_page => 20)

    @meta_title = meta_title "Recent Tweets about #{@coin.full_name} (#{@coin.short_name})"
    @meta_description = "Tweets about #{@coin.full_name} (#{@coin.short_name}) from top social media platforms."
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end
end
