# == Schema Information
#
# Table name: keywords
#
#  created_at :datetime         not null
#  id         :integer          not null, primary key
#  keyword    :text
#  updated_at :datetime         not null
#
# Indexes
#
#  index_keywords_on_keyword  (keyword)
#

class Keyword < ApplicationRecord
end
