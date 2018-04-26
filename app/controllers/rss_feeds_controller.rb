class RssFeedsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @rss_feeds = RssFeed.paginate(:page => params[:page], :per_page => 30)
  end

  def show
    @rss = RssFeed.find(params[:id])
    @feed = Feedjira::Feed.fetch_and_parse(rss.url)
  end

  def fetch_all_rss_feeds
    feeds = RssFeed.where("priority != ?", 0)
    rcount = 0
    feeds.each do |rss|
      next if rss.feed_type == "reddit"
      rss.perform_async.save_entries
      rcount += 1
    end

    redirect_to({ :action => "index", :controller => "rss_feeds" }, :alert => "Entries added for #{rcount} RSS Feeds.")
  end
end
