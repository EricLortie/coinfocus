# == Schema Information
#
# Table name: notifications
#
#  body       :text
#  created_at :datetime         not null
#  global     :boolean          default(FALSE)
#  id         :integer          not null, primary key
#  n_type     :string
#  test       :boolean          default(FALSE)
#  title      :string
#  updated_at :datetime         not null
#

class Notification < ApplicationRecord
  has_many :coin_notifications, :dependent => :destroy
  has_many :coins, :through => :coin_notifications

  def self.global_notifications
    Notification.where(:global => true).last(10)
  end

  def posted_ago_in_words
    "#{ActionController::Base.helpers.distance_of_time_in_words(Time.now.utc, created_at.utc).capitalize} ago"
  end

  def posted_at
    created_at.strftime("%m/%d/%Y - %I:%M%p")
  end
end
