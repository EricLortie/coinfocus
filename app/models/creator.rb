# == Schema Information
#
# Table name: creators
#
#  alexa_rating       :integer
#  created_at         :datetime         not null
#  creator_type       :string
#  description        :text
#  facebook_followers :integer
#  foreign_id         :string
#  id                 :integer          not null, primary key
#  name               :string
#  organization       :string
#  photo_url          :string
#  post_count         :integer
#  reddit_followers   :integer
#  score              :integer
#  sentiment          :decimal(, )
#  twitter_followers  :integer
#  updated_at         :datetime         not null
#  url                :string
#
# Indexes
#
#  index_creators_on_name_and_foreign_id_and_creator_type  (name,foreign_id,creator_type) UNIQUE
#

class Creator < ApplicationRecord
  has_many :social_mentions, :dependent => :destroy

  def title_string
    return name if creator_type == "news"
    "#{creator_type} user #{name}"
  end

  def display_cp_url
    "<a href='/source/#{CGI.escape(name)}'>#{name}</a>".html_safe
  end

  def display_public_url
    "<a href='#{url}' target='_blank'>#{url}</a>".html_safe
  end

  def creator_icon
    fa_icon = "far fa-newspaper"
    fa_icon = "fab fa-reddit-alien" if creator_type == "reddit"
    "<i class='#{fa_icon}'></i>".html_safe
  end

  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.find_each(:batch_size => 10_000).group_by { |model| [model.name, model.foreign_id, model.creator_type] }
    grouped.each_value do |duplicates|
      # the first one we want to keep right?
      duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each(&:destroy) # duplicates can now be destroyed
    end
  end
end
