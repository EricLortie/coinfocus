# == Schema Information
#
# Table name: social_scores
#
#  comments          :integer
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  likes             :integer
#  notes             :string
#  score             :integer
#  shares            :integer
#  social_mention_id :integer
#  updated_at        :datetime         not null
#

class SocialScore < ApplicationRecord
  belongs_to :social_mention

  default_scope { order(:created_at => :desc) }

  def self.calculate_score(social={})
    likes = social[:likes].presence || 0
    shares = social[:shares].presence || 0
    comments = social[:comments].presence || 0
    highest_rank = social[:highest_rank].presence || 0
    likes_score = 0
    share_score = 0
    comment_score = 0
    rank_score = 0

    begin
      if likes > 50 and likes <= 100
        likes_score = 5
      elsif likes > 100 and likes <= 500
        likes_score = 10
      elsif likes > 500 and likes <= 1000
        likes_score = 15
      elsif likes > 1000 and likes <= 5000
        likes_score = 20
      elsif likes > 5000
        likes_score = 33
      end

      if shares > 50 and shares <= 100
        share_score = 5
      elsif shares > 100 and shares <= 500
        share_score = 10
      elsif shares > 500 and shares <= 1000
        share_score = 15
      elsif shares > 1000 and shares <= 5000
        share_score = 20
      elsif shares > 5000
        share_score = 33
      end

      if comments > 10 and comments <= 100
        comment_score = 10
      elsif comments > 100 and comments <= 500
        comment_score = 20
      elsif comments > 5000
        comment_score = 33
      end

      if highest_rank > 10_000 and highest_rank <= 20_000
        rank_score = 5
      elsif highest_rank > 5000 and highest_rank <= 10_000
        rank_score = 10
      elsif highest_rank > 1000 and highest_rank <= 5000
        rank_score = 15
      elsif highest_rank > 500 and highest_rank <= 1000
        rank_score = 20
      elsif highest_rank > 100 and highest_rank <= 500
        rank_score = 25
      elsif highest_rank < 100 and highest_rank > 0
        rank_score = 33
      end
    rescue NoMethodError
      Rails.logger.debug("No method error!")
    end

    (share_score + likes_score + comment_score + rank_score)
  end
end
