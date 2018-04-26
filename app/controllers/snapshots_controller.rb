class SnapshotsController < ApplicationController
  # before_action :authenticate_user!
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
  include WorkerModule

  def index
    @snapshots = Snapshot.all.paginate(:page => params[:page], :per_page => 30)
  end

  def show
  end

  def download_snapshots_csv
    if current_user.present? and current_user.admin?

      Aws.config.update(
        :region => "us-east-1",
        :credentials => Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_ACCESS_SECRET_ACCESS_KEY"])
      )

      s3 = Aws::S3::Resource.new(:region => "us-east-1")
      CSV.open("tmp/snapshots.csv", "w") do |csv|
        csv << Snapshot.csv_attributes
        count = 1
        s3.bucket("coinfocus").objects.collect(&:key).each do |f|
          file = open("https://s3.amazonaws.com/coinfocus/#{f}").readlines
          file.shift
          file.each do |l|
            csv <<  l.split(",")
          end
          count += 1
        end
      end
      send_data open("tmp/snapshots.csv"), :type => "text/csv; charset=iso-8859-1; header=present", :disposition => "attachment;data=ALL DATA #{Time.now.utc}.csv"

    else
      redirect_to({ :action => "index", :controller => "coins" }, :alert => "Acess Denied")
    end
  end

  def queue_all_snapshots
    count = 0

    coins = Rails.env.development? ? Coin.first : Coin.all

    coins.each do |coin|
      price_data = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{coin['short_name']}&tsyms=USD")))
      price_data = price_data["RAW"][coin["short_name"]]["USD"] rescue []
      next if price_data.blank?
      price = price_data["PRICE"].to_f rescue 0
      next if price == 0
      SnapshotWorker.set(:queue => "snapshots").perform_async(coin.id, price_data, Time.now.utc, price)
      count += 1
    end

    redirect_to({ :action => "index", :controller => "coins" }, :alert => "#{count} snapshots queued.")
  end

  def fetch_all_snapshots
    count = 0
    c_count = Rails.env.development? ? 1 : 30
    Coin.first(c_count).each do |coin|
      price_data = JSON.parse(Net::HTTP.get(URI.parse("https://min-api.cryptocompare.com/data/pricemultifull?fsyms=#{coin['short_name']}&tsyms=USD")))
      price_data = price_data["RAW"][coin["short_name"]]["USD"] rescue []
      next if price_data.blank?
      price = price_data["PRICE"].to_f rescue 0
      next if price == 0
      count += 1
      WorkerModule.capture_snapshot(coin.id, price_data, Time.now.utc, price)
    end

    redirect_to({ :action => "index", :controller => "coins" }, :alert => "#{count} snapshots fetched.")
  end

  def fetch_coin_history
    SnapshotWorker.build_histories
    redirect_to({ :action => "index", :controller => "coins" }, :alert => "Coin histories fetched.")
  end

  def build_recent_social_data
    Coin.all.each do |c|
      WorkerModule.capture_snapshot_social_data(c.snapshots.last.id) if c.snapshots.last.present?
    end
    redirect_to({ :action => "index", :controller => "coins" }, :alert => "Social data built.")
  end

  def build_snapshot_monitor
    WorkerModule.build_snapshot_monitor
    redirect_to({ :action => "index", :controller => "coins" }, :alert => "Snapshot Monitor fetched.")
  end

  def calculate_averages_test
    WorkerModule.calculate_averages(Coin.first.latest_snapshot.id)
    redirect_to({ :action => "index", :controller => "coins" }, :alert => "Averages calculated")
  end
end
