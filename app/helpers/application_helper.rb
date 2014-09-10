module ApplicationHelper

  def get_oauth_url

    rediret_uri = "#{Setting.local_url}/oauth"
    "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Setting.appid}&redirect_uri=#{rediret_uri}&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect"
  end
end
