module ApplicationHelper

  def get_oauth_url(mid)

    rediret_uri = "#{Setting.local_url}/oauth"
    if mid.present?
      rediret_uri = "#{rediret_uri}?mid=#{mid}"
    end

    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.appid}&redirect_uri=#{rediret_uri}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect"
  end


end
