# == Schema Information
#
# Table name: averages
#
#  average :decimal(, )      default(0.0)
#  avg_key :string
#  coin_id :integer
#  count   :integer          default(0)
#  id      :integer          not null, primary key
#  length  :integer
#  time    :integer
#  total   :decimal(, )      default(0.0)
#
# Indexes
#
#  index_averages_on_coin_id                                  (coin_id)
#  index_averages_on_coin_id_and_length_and_time_and_avg_key  (coin_id,length,time,avg_key) UNIQUE
#

class Average < ApplicationRecord
  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.find_each(:batch_size => 10_000).group_by { |model| [model.coin_id, model.length, model.time, model.avg_key] }
    grouped.each_value do |duplicates|
      # the first one we want to keep right?
      duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each(&:destroy) # duplicates can now be destroyed
    end
  end
end
