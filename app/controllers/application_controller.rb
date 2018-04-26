class ApplicationController < ActionController::Base
  protect_from_forgery :with => :exception
  before_action :set_query_vars

  BRAND_NAME = "CoinFocus".freeze

  def set_query_vars
    @sm_coin_join = "social_mentions.*, coins.*, creators.name as creator_name, creators.id as creator_id, creators.creator_type as creator_type, creators.url as creator_url"
    @sm_join = "social_mentions.*, creators.name as creator_name, creators.id as creator_id, creators.creator_type as creator_type, creators.url as creator_url"
  end

  def meta_title(title)
    [title, BRAND_NAME].reject(&:empty?).join(" | ")
  end

  before_action :set_time_zone

  def set_time_zone
    Time.zone = current_user.time_zone if current_user
  end

  private

  def verify_admin
    authenticate_user!

    return if current_user.admin

    redirect_to root_url # or whatever
  end
end
