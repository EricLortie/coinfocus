# == Schema Information
#
# Table name: coin_keywords
#
#  coin_id    :integer
#  count      :integer
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  keyword_id :integer
#  posted_at  :datetime
#  updated_at :datetime         not null
#
# Indexes
#
#  index_coin_keywords_on_posted_at  (posted_at)
#

class CoinKeyword < ApplicationRecord
  belongs_to :coin
  belongs_to :keyword
end
