# == Schema Information
#
# Table name: snapshots
#
#  change_values_fixed      :boolean
#  circulating              :decimal(, )      default(0.0)
#  coin_id                  :integer
#  coin_type                :string
#  complete                 :boolean
#  created_at               :datetime         not null
#  daily_chart_data         :text
#  daily_social_data        :text
#  fromsymbol               :string
#  high_24                  :decimal(, )      default(0.0)
#  id                       :integer          not null, primary key
#  keyword_data             :text
#  last_volume              :decimal(, )      default(0.0)
#  last_volume_to           :decimal(, )      default(0.0)
#  low_24                   :decimal(, )      default(0.0)
#  market                   :string
#  market_cap               :decimal(, )      default(0.0)
#  mc_change_1_month        :decimal(, )      default(0.0)
#  mc_change_1_week         :decimal(, )      default(0.0)
#  mc_change_24             :decimal(, )      default(0.0)
#  mc_change_30m            :decimal(, )
#  mc_change_60m            :decimal(, )
#  mc_change_pct_1_month    :decimal(, )      default(0.0)
#  mc_change_pct_1_week     :decimal(, )      default(0.0)
#  mc_change_pct_24         :decimal(, )      default(0.0)
#  mc_change_pct_30m        :decimal(, )
#  mc_change_pct_60m        :decimal(, )
#  monthly_chart_data       :text
#  monthly_social_data      :text
#  news_15m                 :integer
#  news_15m_sentiment       :decimal(, )
#  news_24h                 :integer
#  news_24h_sentiment       :decimal(, )
#  news_30m                 :integer
#  news_30m_sentiment       :decimal(, )
#  news_60m                 :integer
#  news_60m_sentiment       :decimal(, )
#  open_24                  :decimal(, )      default(0.0)
#  price                    :decimal(, )      default(0.0)
#  price_change_1_month     :decimal(, )      default(0.0)
#  price_change_1_week      :decimal(, )      default(0.0)
#  price_change_24          :decimal(, )      default(0.0)
#  price_change_30m         :decimal(, )
#  price_change_60m         :decimal(, )
#  price_change_pct_1_month :decimal(, )      default(0.0)
#  price_change_pct_1_week  :decimal(, )      default(0.0)
#  price_change_pct_24      :decimal(, )      default(0.0)
#  price_change_pct_30m     :decimal(, )
#  price_change_pct_60m     :decimal(, )
#  reddit_15m               :integer
#  reddit_15m_sentiment     :decimal(, )      default(0.0)
#  reddit_24h               :integer
#  reddit_24h_sentiment     :decimal(, )      default(0.0)
#  reddit_30m               :integer
#  reddit_30m_sentiment     :decimal(, )      default(0.0)
#  reddit_60m               :integer
#  reddit_60m_sentiment     :decimal(, )      default(0.0)
#  time_collected           :datetime
#  tosymbol                 :string
#  trending_since           :datetime
#  trending_up              :boolean
#  twitter_15m              :integer
#  twitter_15m_sentiment    :decimal(, )      default(0.0)
#  twitter_24h              :integer
#  twitter_24h_sentiment    :decimal(, )      default(0.0)
#  twitter_30m              :integer
#  twitter_30m_sentiment    :decimal(, )      default(0.0)
#  twitter_60m              :integer
#  twitter_60m_sentiment    :decimal(, )      default(0.0)
#  updated_at               :datetime         not null
#  vol_change_1_month       :decimal(, )      default(0.0)
#  vol_change_1_week        :decimal(, )      default(0.0)
#  vol_change_24            :decimal(, )      default(0.0)
#  vol_change_30m           :decimal(, )
#  vol_change_60m           :decimal(, )
#  vol_change_pct_1_month   :decimal(, )      default(0.0)
#  vol_change_pct_1_week    :decimal(, )      default(0.0)
#  vol_change_pct_24        :decimal(, )      default(0.0)
#  vol_change_pct_30m       :decimal(, )
#  vol_change_pct_60m       :decimal(, )
#  volume_24                :decimal(, )      default(0.0)
#  volume_24_to             :decimal(, )      default(0.0)
#  weekly_chart_data        :text
#  weekly_social_data       :text
#  yearly_chart_data        :text
#  yearly_social_data       :text
#
# Indexes
#
#  index_snapshots_on_coin_id               (coin_id)
#  index_snapshots_on_coin_id_and_complete  (coin_id,complete)
#  index_snapshots_on_complete              (complete)
#  index_snapshots_on_created_at            (created_at)
#  index_snapshots_on_id_and_complete       (id,complete)
#  index_snapshots_on_time_collected        (time_collected)
#  index_snapshots_on_updated_at            (updated_at)
#

class Snapshot < ApplicationRecord
  belongs_to :coin
  serialize :daily_social_data, Hash
  serialize :weekly_social_data, Hash
  serialize :monthly_social_data, Hash
  serialize :yearly_social_data, Hash
  serialize :daily_chart_data, Hash
  serialize :weekly_chart_data, Hash
  serialize :monthly_chart_data, Hash
  serialize :yearly_chart_data, Hash
  serialize :keyword_data, Hash

  default_scope { order(:time_collected => :desc) }

  def self.to_csv(start_time, end_time)
    Aws.config.update(
      :region => "us-east-1",
      :credentials => Aws::Credentials.new(ENV["AWS_ACCESS_KEY_ID"], ENV["AWS_ACCESS_SECRET_ACCESS_KEY"])
    )

    s3 = Aws::S3::Resource.new(:region => "us-east-1")
    # obj = s3.bucket("coinfocus").object("snapshots/snapshot_for_#{Time.now.utc}.csv")
    return if s3.bucket("coinfocus").object("snapshots/snapshot_for_#{start_time}.csv").exists?
    CSV.open("#{Rails.root.join('tmp')}/snapshots-#{start_time}.csv", "w") do |csv|
      csv << csv_attributes
      where("created_at > ? AND created_at < ?", start_time, end_time).find_each do |snapshot|
        next if snapshot.price.blank?
        csv << csv_attributes.map { |attr| format_prop(snapshot.send(attr)) }
      end
    end
    s3.bucket("coinfocus").object("snapshots/snapshot_for_#{start_time}.csv").upload_file("#{Rails.root.join('tmp')}/snapshots-#{start_time}.csv")
  end

  def self.download_csvs_from_s3
  end

  def self.csv_props(coin_id)
    # csv << self.attributes

    item = []
    snapshot = find_by(:complete => true, :coin_id => coin_id)

    csv_attributes.map { |attr| item << format_prop(snapshot.send(attr)) }

    item
  end

  def self.format_prop(prop)
    # puts "#{prop.class.inspect} #{prop.inspect} #{prop == NaN}"
    return prop.to_f if prop.is_a? BigDecimal and !prop.nan?
    return 0 if prop.is_a? BigDecimal and prop.nan?
    return 0 if prop == false
    return 1 if prop == true
    prop
  end

  def self.csv_attributes
    s_attributes = Snapshot.column_names.reject { |c| %w[id market fromsymbol tosymbol last_volume_to updated_at created_at change_values_fixed change_values_fixed complete daily_chart_data daily_social_data keyword_data monthly_chart_data monthly_social_data weekly_chart_data weekly_social_data yearly_chart_data yearly_social_data].include? c }
    s_attributes.push("time_of_day")
    s_attributes.push("day_of_week")
    s_attributes.push("price_in_one_hour")
    s_attributes.push("price_in_three_hours")
    # s_attributes.push("price_in_six_hours")
    # s_attributes.push("price_in_one_day")
    s_attributes
  end

  def day_of_week
    updated_at.strftime("%A")
  end

  def time_of_day
    updated_at.strftime("%H:%M")
  end

  def price_in_one_hour
    f_price = Snapshot.find_by("created_at > ? AND coin_id = ?", (created_at + 1.hour), coin_id).price rescue ""
    return ApplicationController.helpers.parse_change_pct(price, f_price) rescue ""
  end

  def price_in_three_hours
    f_price = Snapshot.find_by("created_at > ? AND coin_id = ?", (created_at + 3.hours), coin_id).price rescue ""
    return ApplicationController.helpers.parse_change_pct(price, f_price) rescue ""
  end

  def price_in_six_hours
    f_price = Snapshot.find_by("created_at > ? AND coin_id = ?", (created_at + 6.hours), coin_id).price rescue ""
    return ApplicationController.helpers.parse_change_pct(price, f_price) rescue ""
  end

  def price_in_one_day
    f_price = Snapshot.find_by("created_at > ? AND coin_id = ?", (created_at + 1.day), coin_id).price rescue ""
    return ApplicationController.helpers.parse_change_pct(price, f_price) rescue ""
  end
end
