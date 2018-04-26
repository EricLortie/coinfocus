namespace :db_fix do
  desc "TODO"
  task :sm_dedupe_feb => :environment do
    SocialMention.dedupe(Date.parse("Febuary 1st 2018")..Date.parse("Febuary 28th 2018"))
  end
end
