namespace :db_fix do
  desc "TODO"
  task :sm_dedupe_mar => :environment do
    SocialMention.dedupe(Date.parse("March 1st 2018")..Date.parse("March 31st 2018"))
  end
end
