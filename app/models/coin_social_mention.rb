# == Schema Information
#
# Table name: coin_social_mentions
#
#  coin_id           :integer
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  social_mention_id :integer
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_coin_social_mentions_on_coin_id            (coin_id)
#  index_coin_social_mentions_on_social_mention_id  (social_mention_id)
#

class CoinSocialMention < ApplicationRecord
  belongs_to :coin
  belongs_to :social_mention
end
