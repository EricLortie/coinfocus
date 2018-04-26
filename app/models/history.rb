# == Schema Information
#
# Table name: histories
#
#  close      :decimal(20, 6)
#  coin_id    :integer
#  high       :decimal(20, 6)
#  id         :integer          not null, primary key
#  length     :integer          default(86400)
#  low        :decimal(20, 6)
#  symbolfrom :string
#  symbolto   :string
#  time       :integer
#  volumefrom :decimal(20, 6)
#  volumeto   :decimal(20, 6)
#
# Indexes
#
#  index_histories_on_coin_id  (coin_id)
#  index_histories_on_time     (time)
#

class History < ApplicationRecord
  belongs_to :coin
  default_scope { order(:time => :desc) }
end
