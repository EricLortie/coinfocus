# == Schema Information
#
# Table name: social_histories
#
#  coin_id           :integer
#  id                :integer          not null, primary key
#  length            :integer
#  news_count        :integer          default(0)
#  news_sentiment    :decimal(, )      default(0.0)
#  reddit_count      :integer          default(0)
#  reddit_sentiment  :decimal(, )      default(0.0)
#  time              :integer
#  twitter_count     :integer          default(0)
#  twitter_sentiment :decimal(, )      default(0.0)
#  urls              :text
#
# Indexes
#
#  index_social_histories_on_coin_id  (coin_id)
#  index_social_histories_on_time     (time)
#

class SocialHistory < ApplicationRecord
  belongs_to :coin
  default_scope { order(:time => :desc) }
end
