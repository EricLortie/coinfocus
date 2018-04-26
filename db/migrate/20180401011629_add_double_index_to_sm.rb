class AddDoubleIndexToSm < ActiveRecord::Migration[5.1]
  def change

    # SocialMention.dedupe(Date.parse("January 1st 2018")..Date.parse("January 31st 2018"))
    # SocialMention.dedupe(Date.parse("Febuary 1st 2018")..Date.parse("Febuary 28th 2018"))
    # SocialMention.dedupe(Date.parse("March 1st 2018")..Date.parse("March 31st 2018"))

    # add_index :social_mentions, [:social_id, :social_type], unique: true

  end
end
