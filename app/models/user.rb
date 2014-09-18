#encoding: utf-8
class User < ActiveRecord::Base

  #********全部字段
  # :access_token
  # :refresh_token
  # :openid
  # :nickname
  # :sex
  # :province
  # :city
  # :country
  # :headimgurl
  # :today_gua_count
  # :last_get_time
  # :hy_count 好友数量
  # :hy_is_award  50个好友是否已经兑换
  # :award_1
  # :award_2
  # :award_3
  # :award_4
  # :award_5
  # :award_6

  # :mobile
  # :go_4
  # :go_5
  #********全部字段


  validates_presence_of    :access_token
  validates_presence_of    :refresh_token
  validates_presence_of    :openid
  validates_presence_of    :nickname
  validates_presence_of    :last_get_time


  validates_uniqueness_of :openid


  
  def sex_name
    sex == 1 ? '男' : '女'
  end


end