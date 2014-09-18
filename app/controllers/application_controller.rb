class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def normal_rand
    org = [1,2,3,4,5,6]
    tmp_array = [1,2,3,4,5,6,1,1]
    tmp_r = rand(1..tmp_array.length)
    tmp_r = tmp_array[tmp_r-1]
    org[tmp_r-1]

  end


  def get_rank(user)
    r = -1
    if user.last_get_time > Time.now.beginning_of_day and user.today_gua_count <= 0
      return r
    end

    array = []
    array << 1 if user.award_1 > 0
    array << 2 if user.award_2 > 0
    array << 3 if user.award_3 > 0
    array << 4 if user.award_4 > 0
    array << 5 if user.award_5 > 0
    array << 6 if user.award_6 > 0


    # 判断这个用户是否已经抽过奖
    if AwardRecord.exists?(user_id: user.id)
      #  已经中过奖
      # 卡片还不到3张,所以随机抽
      if array.length < 3
        r = rand(1..6)
      else # 卡片已经到3张,所以只能在已有的基础上随机抽
        tmp_i = rand(1..array.length)
        r = array[tmp_i - 1]
        p r > 0
      end

    else #还未中过奖
      if array.length < 3
        r = normal_rand

      elsif array.length == 3
        award = Award.where(award_type: 1).first
        if award.count > 0 # 4等奖还有
          r = normal_rand
        else # 4等奖没了
          # 5等奖还有
          award = Award.where(award_type: 2).first
          if award.count > 0
            r = normal_rand
          else
            # 没有4等奖了, 则永远中不了
            tmp_i = rand(1..array.length)
            r = array[tmp_i - 1]
          end

        end

      elsif array.length == 4

        if user.go_4
          award = Award.where(award_type: 2).first
          if award.count > 0
            r = normal_rand
          else
            award = Award.where(award_type: 3).first
            if award.count > 0
              r = normal_rand
            else
              # 没有5等奖了, 则永远中不了
              tmp_i = rand(1..array.length)
              r = array[tmp_i - 1]
            end
          end
        else
          tmp_i = rand(1..array.length)
          r = array[tmp_i - 1]
        end


      elsif array.length == 5
        award = Award.where(award_type: 3).first
        if award.count > 0
          r = normal_rand
        else
          # 没有5等奖了, 则永远中不了
          tmp_i = rand(1..array.length)
          r = array[tmp_i - 1]
        end
      else
        r = normal_rand
      end

    end


    p "随机数=#{r}"

    # 刮卡记录
    Record.create(user_id: user.id, award: r) if r > 0

    r

  end
end
