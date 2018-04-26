# == Schema Information
#
# Table name: snapshot_monitors
#
#  coin_id                :integer
#  created_at             :datetime         not null
#  highest_circulating    :decimal(, )
#  highest_circulating_id :integer
#  highest_market_cap     :decimal(, )
#  highest_market_cap_id  :integer
#  highest_price          :decimal(, )
#  highest_price_id       :integer
#  highest_volume         :decimal(, )
#  highest_volume_id      :integer
#  id                     :integer          not null, primary key
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_snapshot_monitors_on_coin_id                 (coin_id)
#  index_snapshot_monitors_on_highest_circulating_id  (highest_circulating_id)
#  index_snapshot_monitors_on_highest_market_cap_id   (highest_market_cap_id)
#  index_snapshot_monitors_on_highest_volume_id       (highest_volume_id)
#

class SnapshotMonitor < ApplicationRecord
end
