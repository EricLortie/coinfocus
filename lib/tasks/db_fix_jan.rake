namespace :db_fix do
  desc "TODO"
  task :sm_dedupe_jan => :environment do
    SocialMention.dedupe(Date.parse("January 1st 2018")..Date.parse("January 31st 2018"))
  end
end
