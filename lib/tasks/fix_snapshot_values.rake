namespace :snapshots do
  desc "TODO"
  task :fix_change_values => :environment do
    include ActionView::Helpers::NumberHelper
    include ApplicationHelper

    Snapshot.find_each do |s|
      next if s[:price_change_30m].present?
      default = 0.0
      new_params = {}
      coin = s.coin
      new_params[:price_change_30m] = ApplicationController.helpers.parse_change(s.price, coin.price_history_at(s.created_at - 30.minutes, default))
      new_params[:price_change_pct_30m] = ApplicationController.helpers.parse_change_pct(s.price, coin.price_history_at(s.created_at - 30.minutes, default))
      new_params[:price_change_60m] = ApplicationController.helpers.parse_change(s.price, coin.price_history_at(s.created_at - 60.minutes, default))
      new_params[:price_change_pct_60m] = ApplicationController.helpers.parse_change_pct(s.price, coin.price_history_at(s.created_at - 60.minutes, default))
      # new_params[:price_change_24] = ApplicationController.helpers.parse_change(s.price, coin.price_history_at(s.created_at - 1.day, default))
      # new_params[:price_change_pct_24] = ApplicationController.helpers.parse_change_pct(s.price, coin.price_history_at(s.created_at - 1.day, default))
      # new_params[:price_change_1_week] = ApplicationController.helpers.parse_change(s.price, coin.price_history_at(s.created_at - 1.week, default))
      # new_params[:price_change_pct_1_week] = ApplicationController.helpers.parse_change_pct(s.price, coin.price_history_at(s.created_at - 1.week, default))
      # new_params[:price_change_1_month] = ApplicationController.helpers.parse_change(s.price, coin.price_history_at(s.created_at - 1.month, default))
      # new_params[:price_change_pct_1_month] = ApplicationController.helpers.parse_change_pct(s.price, coin.price_history_at(s.created_at - 1.month, default))
      new_params[:mc_change_30m] = ApplicationController.helpers.parse_change(s.market_cap, coin.mc_history_at(s.created_at - 30.minutes, default))
      new_params[:mc_change_pct_30m] = ApplicationController.helpers.parse_change_pct(s.market_cap, coin.mc_history_at(s.created_at - 30.minutes, default))
      new_params[:mc_change_60m] = ApplicationController.helpers.parse_change(s.market_cap, coin.mc_history_at(s.created_at - 60.minutes, default))
      new_params[:mc_change_pct_60m] = ApplicationController.helpers.parse_change_pct(s.market_cap, coin.mc_history_at(s.created_at - 60.minutes, default))
      # new_params[:mc_change_24] = ApplicationController.helpers.parse_change(s.market_cap, coin.mc_history_at(s.created_at - 1.day, default))
      # new_params[:mc_change_pct_24] = ApplicationController.helpers.parse_change_pct(s.market_cap, coin.mc_history_at(s.created_at - 1.day, default))
      # new_params[:mc_change_1_week] = ApplicationController.helpers.parse_change(s.market_cap, coin.mc_history_at(s.created_at - 1.week, default))
      # new_params[:mc_change_pct_1_week] = ApplicationController.helpers.parse_change_pct(s.market_cap, coin.mc_history_at(s.created_at - 1.week, default))
      # new_params[:mc_change_1_month] = ApplicationController.helpers.parse_change(s.market_cap, coin.mc_history_at(s.created_at - 1.month, default))
      # new_params[:mc_change_pct_1_month] = ApplicationController.helpers.parse_change_pct(s.market_cap, coin.mc_history_at(s.created_at - 1.month, default))
      new_params[:vol_change_30m] = ApplicationController.helpers.parse_change(s.volume_24_to, coin.vol_history_at(s.created_at - 30.minutes, default))
      new_params[:vol_change_pct_30m] = ApplicationController.helpers.parse_change_pct(s.volume_24_to, coin.vol_history_at(s.created_at - 30.minutes, default))
      new_params[:vol_change_60m] = ApplicationController.helpers.parse_change(s.volume_24_to, coin.vol_history_at(s.created_at - 60.minutes, default))
      new_params[:vol_change_pct_60m] = ApplicationController.helpers.parse_change_pct(s.volume_24_to, coin.vol_history_at(s.created_at - 60.minutes, default))
      # new_params[:vol_change_24] = ApplicationController.helpers.parse_change(s.volume_24_to, coin.vol_history_at(s.created_at - 1.day, default))
      # new_params[:vol_change_pct_24] = ApplicationController.helpers.parse_change_pct(s.volume_24_to, coin.vol_history_at(s.created_at - 1.day, default))
      # new_params[:vol_change_1_week] = ApplicationController.helpers.parse_change(s.volume_24_to, coin.vol_history_at(s.created_at - 1.week, default))
      # new_params[:vol_change_pct_1_week] = ApplicationController.helpers.parse_change_pct(s.volume_24_to, coin.vol_history_at(s.created_at - 1.week, default))
      # new_params[:vol_change_1_month] = ApplicationController.helpers.parse_change(s.volume_24_to, coin.vol_history_at(s.created_at - 1.month, default))
      # new_params[:vol_change_pct_1_month] = ApplicationController.helpers.parse_change_pct(s.volume_24_to, coin.vol_history_at(s.created_at - 1.month, default))
      new_params[:change_values_fixed] = true
      s.update(new_params) if new_params.present?
    end
  end
end
