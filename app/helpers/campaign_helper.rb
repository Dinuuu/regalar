module CampaignHelper
  def youtube_embed(youtube_url)
    if youtube_url[/youtu\.be\/([^\?]*)/]
      youtube_id = Regexp.last_match[1]
    else
      youtube_url[/^.*((v%r)|(embed%r)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = Regexp.last_match[5]
    end
    %Q(http://www.youtube.com/embed/#{ youtube_id })
  end
end
