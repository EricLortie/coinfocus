class NotificationsController < ApplicationController
  def coin_notifications
    @coin = Coin.find(params[:coin_id])
    @notifications = @coin.recent_notifications
    @identifier = @coin.short_name
    render :template => "notifications/_recent"
  end

  def test_notifications
    WorkerModule.test_notifications
    redirect_to({ :action => "index", :controller => "home" }, :alert => "Notification test sent!")
  end

  def test_coin_notifications
    WorkerModule.test_coin_notifications
    redirect_to({ :action => "index", :controller => "home" }, :alert => "BTC notification test sent!")
  end
end
