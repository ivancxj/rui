#encoding: utf-8
# 朋友表
class Friend < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend, class_name: 'User'
  #********全部字段

  #********全部字段

  validates_uniqueness_of :user_id,  scope: :friend_id, message: '已经是朋友'

end