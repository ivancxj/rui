#encoding: utf-8
# 奖品
class Award < ActiveRecord::Base

  #********全部字段
  # :award_type 奖品 1:充电宝 2:电影票 3:料理机 4:电影票
  # :name
  # :count
  #********全部字段


  validates_presence_of    :award_type
  validates_uniqueness_of  :award_type


#   凑齐4个,充电宝(60) 凑齐5个,电影票(50)  凑齐6个,料理机(2)
#   累计获得50个好友即可获得电影票两张,总共20张双人票


end