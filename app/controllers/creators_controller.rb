class CreatorsController < ApplicationController
  def index
  end

  def show
    @creator = Creator.find_by(:name => CGI.unescape(params[:name]))
    @coin_social_mentions = SocialMention.joins(:creator)
                                         .select(@sm_join)
                                         .where(:creator_id => @creator.id).paginate(:page => params[:page], :per_page => 10)

    @meta_title = meta_title "Content by #{@creator.name}"
    @meta_description = "Content by #{@creator.title_string} about Cryptocurrencies"
    @og_properties = {
      :title => @meta_title,
      :type => "website",
      :image => view_context.image_url("logo.png"), # this file should exist in /app/assets/images/logo.png
    }
  end
end
