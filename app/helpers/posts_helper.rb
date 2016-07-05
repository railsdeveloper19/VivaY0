module PostsHelper
  require 'emoticon_fontify'
  def display_event_time(event)
    if event and event.created_at
      dis = distance_of_time_in_words_to_now(event.created_at).gsub(/about /,'')
      if dis.split(' ').include?("day")
        return "Yesterday #{event.created_at.strftime("%I:%S%p")}"
      elsif dis.split(' ').include?("days")
        return "#{event.created_at.strftime("%d %b %Y  %I:%S%p")}"
      elsif (dis.split(' ').include?("less") && dis.split(' ').include?("than"))
        return dis
      else
        return dis+" ago"
      end
    else
      return ""
    end
  end
  
  def get_comments(post)
    post.comments.order("created_at DESC").first(4) rescue []
  end
  
  def smileys(str)
    EmoticonFontify.emoticon_fontify(str).html_safe.to_s
  end

  def read_notification
    notify_key_unread = 'bloggerlive_notify_unread' + current_user.id.to_s
    notify_key_read = 'bloggerlive_notify_read' + current_user.id.to_s
    list_range_unread = $redis.llen(notify_key_unread)
    list_range_read= $redis.llen(notify_key_read)
    @redis_notifications_unread = $redis.lrange(notify_key_unread,0,list_range_unread).reverse rescue []
    @redis_notifications_read = $redis.lrange(notify_key_read,list_range_read - 10,list_range_read).reverse rescue []
    @redis_notifications = @redis_notifications_unread + @redis_notifications_read
  end
  def create_notification(post,purpose)
    if (post.user.id != current_user.id)
      notification = ''
      notifier_img = ''
      notify_comment = ''
      notify_key = ''
      
      if current_user.avatar.url.include?("missing")
        notifier_img = "<img src='/assets/default_avtar.jpeg' style = 'height:35px;width:35px;'/>"
      else
        notifier_img = "<img src='#{current_user.avatar.url}' style = 'height:35px;width:35px;'/>"
      end
      
      notify_comment = smileys(params[:comment]).truncate(35) if purpose == 'comment on' 
      notification = "<li role ='presentation'><a href = '/posts/#{post.id}/show_post_and_comment'><div class='media'><div class='pull-left'>#{notifier_img}</div><div class='media-body'><h6 class='media-heading'>#{current_user.name.split(' ')[0]}<small><span style='text-color:blue;'>#{purpose} </span><br/><b>#{post.title.truncate(30)}</b></small></h6>#{notify_comment}<h6 class='media-heading' style= 'margin-top:6px;'><small style='color:grey;'>#{Time.now.strftime('%d %b %Y  %I:%S%p')}</small></h6></div></div></a></li>".html_safe.to_s

      notify_key = 'bloggerlive_notify_unread' + post.user.id.to_s
      
      $redis.rpush(notify_key,notification)
    end 
  end
end
