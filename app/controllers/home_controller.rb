class HomeController < ApplicationController
  def index
    @meta_title = meta_title "Cryptocurrency Price Tracking & Social Analytics"
    @meta_description = "Machine Learning powered Cryptocurrency analysis platform. Up to date snapshots of top cryptocurrencies with data from multiple sources."
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
    @coin = Coin.first
    @global_notifications = Notification.last(5)
  end

  def about
    @meta_title = meta_title "Cryptocurrency Price Tracking & Social Analytics"
    @meta_description = "Artificial Intelligence & Machine Learning powered Cryptocurrency analysis platform"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def blog
    @meta_title = meta_title "Blog, News & Articles"
    @meta_description = "Articles About Top Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def features
    @meta_title = meta_title "Features & Functionality"
    @meta_description = "Artificial Intelligence, Machine Learning, Predictions, Social Tracking, Data Analysis"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"),  # this file should exist in /app/assets/images/logo.png
    }
  end

  def build_recent_data
    WorkerModule.build_recent_data
    redirect_to({ :action => "index", :controller => "home" }, :alert => "Recent data collected")
  end
end
