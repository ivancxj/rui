#encoding: utf-8
class Share < ActiveRecord::Base

  #********全部字段
  # :share_user_id
  # :click_user_id
  # :share_time
  #********全部字段

  validates_presence_of    :share_user_id
  validates_presence_of    :click_user_id
  validates_presence_of    :share_time

end