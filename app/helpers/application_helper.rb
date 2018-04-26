module ApplicationHelper
  def meta_og_tags(properties={})
    return unless properties.is_a? Hash

    tags = []

    properties.each do |property, value|
      tags << tag(:meta, :property => "og:#{property}", :content => value)
    end

    tags.join.html_safe # Remember in Ruby the last line is returned
  end

  def external_img(url)
    "https://www.cryptocompare.com#{url}"
  end

  def get_social_notice(type)
    if !current_user
      return "60 minutes" if type != "news"
      return "3 hours" if type == "news"
    elsif current_user.role != USER_PREMIUM_ROLE
      return "20 minutes" if type != "news"
      return "1 hour" if type == "news"
    end
  end

  def trend_indicator(up)
    return content_tag(:i, "", :class => "fas pct-indicator fa-arrow-circle-#{up ? 'up' : 'down'}") rescue "--"
  end

  def pct_change_indicator(pct)
    return content_tag(:i, "", :class => "fas pct-indicator fa-arrow-circle-#{pct.to_i > 0 ? 'down' : 'up'}") rescue "--"
  end

  def parse_change(now_val, then_val)
    # raise "#{now_val.to_f.inspect} - #{then_val.to_f.inspect} = #{(now_val.to_f - then_val.to_f)}"
    (now_val.to_f - then_val)
  end

  def active_class(link_path)
    request.original_fullpath == link_path ? "active" : ""
  end

  def parse_change_pct(now_val=0, then_val=0)
    return 0.00 if now_val.blank? or then_val.blank?
    ret = number_with_precision((then_val - now_val.to_f) / now_val * 100, :precision => 2)
    ret
  end

  def clean_num_value(num)
    return "#{number_with_precision(num / 1_000_000_000)}B" if num.abs > 1_000_000_000
    return "#{number_with_precision(num / 1_000_000)}M" if num.abs > 1_000_000
    num
  end

  def devise_mapping
    @devise_mapping ||= request.env["devise.mapping"]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def fetch_single_rss(url)
    require "rss"
    require "open-uri"
    rss_results = []
    rss = RSS::Parser.parse(open(url).read, :'User-agent' => "Coin Focus Bot")

    rss.items.each do |result|
      result = { :title => result.title, :date => result.pubDate, :link => result.link, :description => result.description }
      rss_results.push(result)
    end
    rss_results
  end

  def fetch_all_rss
    RssFeed.all.each do |rss|
      # Rails.logger.debug fetch_single_rss(rss.url)
    end
  end

  def creator_icon(type)
    fa_icon = "far fa-newspaper"
    fa_icon = "fab fa-reddit-alien" if type == "reddit"
    fa_icon = "fab fa-twitter" if type == "twitter"
    "<i class='#{fa_icon}'></i>".html_safe
  end

  def creator_cp_url(name)
    "<a href='/source/#{CGI.escape(name)}'>#{name}</a>".html_safe
  end

  def creator_public_url(url)
    "<a href='#{url}' target='_blank'>#{url}</a>".html_safe
  end

  def convert_moment(t)
    t.strftime("%Y-%m-%dT%H:%M:%S%z") rescue "N/A"
  end
end
