#encoding: utf-8
class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :access_token
      t.string  :refresh_token
      t.string  :openid
      t.string  :nickname

      t.integer :sex, default: 1
      t.string  :province
      t.string  :city
      t.string  :country
      t.string  :headimgurl
      t.integer  :today_gua_count, default: 2
      t.datetime :last_get_time

      t.integer  :award_1, default: 0
      t.integer  :award_2, default: 0
      t.integer  :award_3, default: 0
      t.integer  :award_4, default: 0
      t.integer  :award_5, default: 0
      t.integer  :award_6, default: 0

      t.string  :name, comment: '姓名'
      t.string  :address, comment: '地址'
      t.string  :mobile
      t.boolean :go_4, default: false
      t.boolean :go_5, default: false
      t.integer :hy_count, default: 0, comment: '累计获得的好友'
      t.boolean :hy_is_award, default: false, comment: '50个好友是否已经兑换'

      t.timestamps
    end

  end
end
