#encoding: utf-8
class HomeController < ApplicationController
  skip_before_filter :controller_authorize

  
  before_filter {
    
  }

  def app_id
    'wxc03cada76c465d33'
  end

  def app_secret
    'bcc611375a39d14a5e61e79b0375a394'
  end
  
  def index
    
  end

  def oauth
    code = params[:code]

    response = RestClient.get("https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{app_id}&secret=#{app_secret}&code=#{code}&grant_type=authorization_code")
    response = JSON.parse(response)
    # p response

    access_token = response['access_token']
    refresh_token = response['refresh_token']
    @openid = response['openid']

    user = User.where(openid: @openid).first


    if user.present?

      if user.last_get_time < Time.now.beginning_of_day
        user.today_gua_count = Setting.every_day_gua
        user.last_get_time = Time.now
        user.save
      end

    else

      userinfo_url = "https://api.weixin.qq.com/sns/userinfo?access_token=#{access_token}&openid=#{@openid}&lang=zh_CN"
      response = RestClient.get(userinfo_url)

      if response.code == 200
        response = JSON.parse(response)
        p response
        nickname = response['nickname']
        sex = response['sex']
        province = response['province']
        city = response['city']
        country = response['country']
        headimgurl = response['headimgurl']

        opt={}
        opt[:access_token] = access_token
        opt[:refresh_token] = refresh_token
        opt[:openid] = @openid
        opt[:nickname] = nickname
        opt[:sex] = sex
        opt[:province] = province
        opt[:city] = city
        opt[:country] = country
        opt[:headimgurl] = headimgurl
        opt[:today_gua_count] = Setting.every_day_gua
        opt[:last_get_time] = Time.now
        user = User.new(opt)
        user.save

      end


    end


    mid = params[:mid]
    # 用户分享过来的
    if mid.present?
      share_user = User.where(id: mid).first
      if share_user.present?

        opt = {}
        opt[:share_user_id] = share_user.id
        opt[:click_user_id] = user.id
        opt[:share_time] = Time.now.strftime('%Y%m%d').to_i
        # 如果当前不存在,才增加
        unless Share.exists?(opt)
          share = Share.new(opt)
          share.save

          # 重新计算当天的剩余抽奖次数
          if share_user.last_get_time < Time.now.beginning_of_day
            share_user.today_gua_count = Setting.every_day_gua + 1
          else
            share_user.today_gua_count = share_user.today_gua_count + 1
          end
          share_user.last_get_time = Time.now

          friend = Friend.new(user_id: share_user.id, friend_id: user.id)
          if friend.save
            share_user.hy_count = share_user.hy_count + 1
          end
          share_user.save

        end

      end

    end

    # 默认次数
    @gua_count = user.today_gua_count
    @user_id = user.id

    # @openid = '111'
    # @gua_count = 3
  end



  def gua
    openid = params[:openid]
    user = User.where(openid: openid).first
    # @today_gua_count = 0
    r = rand(1..6)
    if user.present?

      # 隔天
      if user.last_get_time < Time.now.beginning_of_day
        user.today_gua_count = Setting.every_day_gua - 1
        user.last_get_time = Time.now
        if(r == 1)
          user.award_1 = user.award_1 + 1
        elsif(r == 2)
          user.award_2 = user.award_2 + 1
        elsif(r == 3)
          user.award_3 = user.award_3 + 1
        elsif(r == 4)
          user.award_4 = user.award_4 + 1
        elsif(r == 5)
          user.award_5 = user.award_5 + 1
        elsif(r == 6)
          user.award_6 = user.award_6 + 1
        end

        user.save
      else
        if user.today_gua_count > 0
          user.today_gua_count = user.today_gua_count - 1
          user.last_get_time = Time.now
          if(r == 1)
            user.award_1 = user.award_1 + 1
          elsif(r == 2)
            user.award_2 = user.award_2 + 1
          elsif(r == 3)
            user.award_3 = user.award_3 + 1
          elsif(r == 4)
            user.award_4 = user.award_4 + 1
          elsif(r == 5)
            user.award_5 = user.award_5 + 1
          elsif(r == 6)
            user.award_6 = user.award_6 + 1
          end
          user.save

        else
          render json: {:gua_count => -1}
          return
        end
      end

      # @today_gua_count = user.today_gua_count
      render json: {:gua_count => user.today_gua_count, :award => r}
    else
      render json: {:gua_count => -1}
    end

  end

end
