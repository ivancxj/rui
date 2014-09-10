#encoding: utf-8
class Award < ActiveRecord::Base

  #********全部字段
  # :award_type
  # :name
  # :img
  #********全部字段


  validates_presence_of    :award_type




end