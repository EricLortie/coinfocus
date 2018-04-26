namespace :db_fix do
  desc "TODO"
  task :sm_dedupe => :environment do
    SocialMention.dedupe(Date.parse("Febuary 1st 2018")..Time.zone.today)
  end
end
