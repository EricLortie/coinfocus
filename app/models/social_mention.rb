# == Schema Information
#
# Table name: social_mentions
#
#  coin_short_names :string           default([]), is an Array
#  created_at       :datetime         not null
#  creator_id       :integer
#  id               :integer          not null, primary key
#  latest_score     :integer          default(0)
#  posted_at        :datetime
#  sentiment        :string
#  social_body      :text
#  social_id        :string
#  social_title     :string
#  social_type      :string
#  updated_at       :datetime         not null
#  url              :string
#
# Indexes
#
#  index_social_mentions_on_posted_at                  (posted_at)
#  index_social_mentions_on_social_id                  (social_id)
#  index_social_mentions_on_social_id_and_social_type  (social_id,social_type) UNIQUE
#

class SocialMention < ApplicationRecord
  has_many :coin_social_mentions, :dependent => :destroy
  has_many :coins, :through => :coin_social_mentions
  has_many :social_scores, :dependent => :destroy
  belongs_to :creator

  validates_uniqueness_of :social_id, :scope => %i[social_id social_type]

  default_scope { order(:posted_at => :desc) }

  def all_news
    social_mentions.where("social_type = ?", "news")
  end

  def all_social
    social_mentions.where("social_type IN ?", ["reddit"])
  end

  def web_safe_url
    return url if url == "N/A"
    prefix = ""
    prefix = "http://reddit.com" if social_type == "reddit"
    "<a href='#{prefix}#{url}' target='_blank'>#{prefix}#{url}</a>"
  end

  def important?
    social_scores.first.score > 20 rescue false
  end

  def displayed_title
    social_title.presence || social_body[0, 150] + "... (read more)"
  end

  def self.latest_reddit
    SocialMention.find_by(:social_type => "reddit")
  end

  def self.social_mention_limit(social_type, current_user)
    if !current_user
      return 60.minutes.ago.utc if social_type != "news"
      return 3.hours.ago.utc if social_type == "news"
    elsif current_user.role != USER_PREMIUM_ROLE
      return 20.minutes.ago.utc if social_type != "news"
      return 1.hour.ago.utc if social_type == "news"
    end
    Time.now.utc
  end

  def self.dedupe(date_range)
    # find all models and group them on keys which should be common
    date_range.each do |date|
      grouped = where("posted_at < ? AND posted_at > ?", date, date - 1.day).find_each(:batch_size => 10_000).group_by { |model| [model.social_id, model.social_type] }
      grouped.each_value do |duplicates|
        # the first one we want to keep right?
        duplicates.shift # or pop for last one
        # if there are any more left, they are duplicates
        # so delete all of them
        duplicates.each(&:destroy) # duplicates can now be destroyed
      end
    end
  end
end
