#encoding: utf-8
# 兑奖记录
class AwardRecord < ActiveRecord::Base

  belongs_to :user
  belongs_to :award
  #********全部字段
  # :weixin_name
  # :name
  # :mobile
  #********全部字段

  validates_presence_of    :user_id
  validates_presence_of    :award_id


#   凑齐4个,充电宝(60) 凑齐5个,电影票(50)  凑齐6个,料理机(2)
#   累计获得50个好友即可获得电影票两张,总共20张双人票



end