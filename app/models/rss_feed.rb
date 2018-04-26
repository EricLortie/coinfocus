# == Schema Information
#
# Table name: rss_feeds
#
#  coin_id      :integer
#  created_at   :datetime         not null
#  id           :integer          not null, primary key
#  last_fetched :datetime
#  params       :text
#  priority     :integer          default(0)
#  rss_type     :string
#  updated_at   :datetime         not null
#  url          :string
#

class RssFeed < ApplicationRecord
  belongs_to :coin
  has_many :entries, :dependent => :destroy

  def entry_count
    entries.length
  end

  def save_entries
    feed = Feedjira::Feed.fetch_and_parse(url.tr(" ", "_"))
    count = 0
    feed.entries.reject { |f| last_fetched.blank? or f.updated < last_fetched }.each do |entry|
      Entry.create(:title => entry.title, :foreign_id => entry.id, :author => entry.author, :content => entry.content)
      count += 1
    end
    update(:last_fetched => Time.now.utc)
  end
end
