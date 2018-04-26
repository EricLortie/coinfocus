# == Schema Information
#
# Table name: system_variables
#
#  created_at                     :datetime         not null
#  id                             :integer          not null, primary key
#  reddit_comment_stream_active   :integer          default(0)
#  reddit_post_stream_active      :boolean          default(FALSE)
#  reddit_subreddit_worker_active :boolean          default(FALSE)
#  twitter_stream_active          :integer          default(0)
#  updated_at                     :datetime         not null
#

class SystemVariable < ApplicationRecord
end
