module SnapshotHelper
  def social_val(coin, type, tf)
    coin["snapshot_#{type}_#{tf}"]
    # count = coin["snapshot_#{type}_#{tf}"]
    # sentiment = coin["snapshot_#{type}_#{tf}_sentiment"]
    # sentiment = 0 if sentiment.blank?
    # "#{count}: #{count == 0 ? '<span>--</span>' : sentiment_display(sentiment)}".html_safe
  end

  def sentiment_display(s)
    sentiment = s > 0 ? "up" : "down"
    # s_total = (s.abs > 100 ? 100 : s.abs) * 100
    icons = ["<i class='fas fa-thumbs-#{sentiment}' aria-hidden='true'></i>"]
    "<span class='#{s >= 0 ? 'positive' : 'negative'}'>#{icons.join}#{" #{s.round}" if current_user&.admin?}</span>".html_safe
  rescue StandardError
    "<span>--</span>".html_safe
  end
end
