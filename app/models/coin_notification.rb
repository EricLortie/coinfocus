# == Schema Information
#
# Table name: coin_notifications
#
#  coin_id         :integer
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  notification_id :integer
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_coin_notifications_on_coin_id          (coin_id)
#  index_coin_notifications_on_notification_id  (notification_id)
#

class CoinNotification < ApplicationRecord
  belongs_to :coin
  belongs_to :notification
end
