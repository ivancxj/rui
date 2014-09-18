#encoding: utf-8
class HomeController < ApplicationController
  # skip_before_filter :controller_authorize
  skip_before_filter :verify_authenticity_token
  
  before_filter {
    
  }

  def app_id
    'wxc03cada76c465d33'
  end

  def app_secret
    'bcc611375a39d14a5e61e79b0375a394'
  end
  
  def index
    @mid=params[:mid]
    
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
        user.today_gua_count = user.today_gua_count + Setting.every_day_gua
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
    if mid.present? and mid != @openid
      share_user = User.where(openid: mid).first
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

    # @openid = 'ozmMMt8Irb8htU_jlRVX3Ekkzov8'
    # user = User.where(openid: @openid).first
    # @gua_count = user.today_gua_count
  end



  def gua
    openid = params[:openid]
    user = User.where(openid: openid).first
    # @today_gua_count = 0

    if user.present?
      # 隔天
      if user.last_get_time < Time.now.beginning_of_day

        r = get_rank(user)

        if r > 0
          user.today_gua_count = user.today_gua_count + Setting.every_day_gua - 1
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
        end

      else
        if user.today_gua_count > 0

          r = get_rank(user)

          if r > 0
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
          end

        else
          render json: {:gua_count => -1}
          return
        end
      end

      array = []
      array << 1 if user.award_1 > 0
      array << 2 if user.award_2 > 0
      array << 3 if user.award_3 > 0
      array << 4 if user.award_4 > 0
      array << 5 if user.award_5 > 0
      array << 6 if user.award_6 > 0

      element_count = array.length
      p "element_count数=#{element_count}"
      can_award = false
      if element_count == 4
        unless user.go_4
          award = Award.where(award_type: 1).first
          can_award = true if award.count > 0
        end

      elsif element_count == 5
        unless user.go_5
          award = Award.where(award_type: 2).first
          can_award = true if award.count > 0
        end
      else
        award = Award.where(award_type: 3).first
        can_award = true if award.count > 0
      end

      #  如果不能兑奖, 则返回 -1
      element_count = -1 unless can_award

      render json: {:gua_count => user.today_gua_count, :award => r, element_count: element_count}
    else
      render json: {:gua_count => -1}
    end

    # render json: {:gua_count => 6, :award => 3}

  end

  def my
    @openid = params[:openid]

    @award_1 = 0
    @award_2 = 0
    @award_3 = 0
    @award_4 = 0
    @award_5 = 0
    @award_6 = 0
    if @openid.present?
      u = User.where(openid: @openid).first
     if u.present?
       @award_1 = u.award_1
       @award_2 = u.award_2
       @award_3 = u.award_3
       @award_4 = u.award_4
       @award_5 = u.award_5
       @award_6 = u.award_6
     end



    end
  end

  # 助阵好友列表
  def friend

    @openid = params[:openid]
    @count = 0
    @can_award = true

    if @openid.present?
      u = User.where(openid: @openid).first
      if u.present?
        @count = u.hy_count

        if AwardRecord.exists?(user_id: u.id, award_id: 4)
          @can_award = false
        else

          if u.hy_count >= 50# 好友数大于50
            award = Award.where(award_type: 4).first
            if award.count <= 0
              @can_award = false
            end
          end

        end

      end
    end

  end

  # 活动介绍
  def jieshao

  end

  # 获奖名单
  def mingdan
    @award_records = AwardRecord.includes(:award).order(id: :desc).all
  end

  # 兑换奖品
  def duihuan
    openid = params[:openid]
    weixin_name = params[:weixin_name]
    name = params[:name]
    mobile = params[:mobile]
    element_count = params[:element_count]
    if element_count.present?
      element_count = element_count.to_i
    else
      element_count = 0
    end

    is_hy = params[:is_hy]

    if openid.present?
      u = User.where(openid: openid).first
      if u.present?

        array = []
        array << 1 if u.award_1 > 0
        array << 2 if u.award_2 > 0
        array << 3 if u.award_3 > 0
        array << 4 if u.award_4 > 0
        array << 5 if u.award_5 > 0
        array << 6 if u.award_6 > 0

        length = array.length

        if is_hy == 'true'
          if u.hy_count >= 50
            award = Award.where(award_type: 4).first
            if award.present? and award.count > 0
              if AwardRecord.exists?(user_id: u.id, award_id: award.id)
                return render json: {:status => -1, msg: '您已经兑过了,不能再兑换'}
              else
                opt = {}
                opt[:user_id] = u.id
                opt[:award_id] = award.id
                opt[:weixin_name] = weixin_name
                opt[:name] = name
                opt[:mobile] = mobile

                ar = AwardRecord.new(opt)
                ar.save

                award.count = award.count - 1
                award.save


                return render json: {:status => 1}
              end
            else
              return render json: {:status => -1, msg: '奖品已经被兑完了'}
            end

          else
            return render json: {:status => -1, msg: '获得50个好友才可以兑换'}
          end

        else


          if length >= 4
            element_count = length if element_count == 0

            if element_count == 4
              if u.go_4
                return render json: {:status => -1, msg: '您选择了继续刮奖,集齐5个才可以兑奖'}
              end
            elsif element_count == 5
              if u.go_5
                return render json: {:status => -1, msg: '您选择了继续刮奖,集齐6个才可以兑奖'}
              end
            end



            array = array[0..element_count-1]
            array.each do |i|
              # 数量-1
              case i
                when 1
                  u.award_1 = (u.award_1) -1
                when 2
                  u.award_2 = (u.award_2) -1
                when 3
                  u.award_3 = (u.award_3) -1
                when 4
                  u.award_4 = (u.award_4) -1
                when 5
                  u.award_5 = (u.award_5) -1
                when 6
                  u.award_6 = (u.award_6) -1
              end
            end

            u.save

            award = Award.where(award_type: element_count - 3).first
            if award.present? and award.count > 0
              opt = {}
              opt[:user_id] = u.id
              opt[:award_id] = award.id
              opt[:weixin_name] = weixin_name
              opt[:name] = name
              opt[:mobile] = mobile

              ar = AwardRecord.new(opt)
              ar.save

              award.count = award.count - 1
              award.save

              render json: {:status => 1}

            else

              render json: {:status => -1, msg: '奖品已经被兑完了'}
            end
          else
            render json: {:status => -1, msg: '卡片起码4张才可以兑奖'}
          end


        end
      else

        render json: {:status => -1, msg: '无效用户'}
      end
    else
      render json: {:status => -1, msg: '无效用户'}

    end



  end

  # 继续刮奖
  def go_gua
    openid = params[:openid]
    element_count = params[:element_count]

    if openid.present?
      u = User.where(openid: openid).first
      if u.present?
        if element_count.to_i == 4
          u.go_4 = true
        elsif element_count.to_i == 5
          u.go_5 = true
        end
        u.save if u.changed?
      end
    end

    render json: {:status => 1}

  end

end
