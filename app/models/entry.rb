# == Schema Information
#
# Table name: entries
#
#  author      :string
#  content     :text
#  created_at  :datetime         not null
#  entry_type  :string
#  foreign_id  :string
#  id          :integer          not null, primary key
#  rss_feed_id :integer
#  title       :string
#  updated_at  :datetime         not null
#

class Entry < ApplicationRecord
  belongs_to :rss_feed
end
