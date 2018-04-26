$(document).on 'ready page:load', ->
  App.notifications = App.cable.subscriptions.create "NotificationsChannel",
    connected: ->
      # Called when the subscription is ready for use on the server
      console.log("action cable connected");

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      console.log("New action cable data");
      coin_links = ""
      coin_links = "COIN</br>FOCUS" if typeof data.coin_links == "undefined"
      data.notif.body = "" if data.notif.body == null
      for coin in data.coin_links
        coin_links += "<a href="+coin+">"+coin.substr(coin.lastIndexOf('/') + 1)+"</a> "
      # Called when there's incoming data on the websocket for this channel
      notif_html = """<div class="row socialRow">
        <div class="coinListValue col-sm-2">
          <h5>#{coin_links}</h5>
        </div>
        <div class="coinListValue col-sm-10">
          <h5 class="notif_time notif_time">#{window.toTimeZone(data.created_at, $('meta[name=user_tz]').attr("content"))}</h4>
          <h4 class="notif_title">#{data.notif.title}</h3>
          <p class="notif_body">#{data.notif.body}</p>
        </div>
      </div>
      """

      selectors = data.coin_ids
      selectors = [data.n_type] if typeof selectors == "undefined"
      for selector in selectors
        if $('.notifications_list'+selector).length > 0
          $('.notifications_list'+selector).append notif_html
          $('.notifications_list'+selector).animate({scrollTop: $('.notifications_list'+selector)[0].scrollHeight - $('.notifications_list'+selector)[0].clientHeight}, 1000)

        if $('.home_notifications_list').length > 0
          $('.home_notifications_list').append notif_html
          $('.home_notifications_list').animate({scrollTop: $('.home_notifications_list')[0].scrollHeight - $('.home_notifications_list')[0].clientHeight}, 1000)