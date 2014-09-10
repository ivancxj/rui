#encoding: utf-8
# 个人每天领奖记录
class Record < ActiveRecord::Base

  belongs_to :user
  belongs_to :award
  #********全部字段

  #********全部字段



end