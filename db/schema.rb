# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140910150149) do

  create_table "awards", force: true do |t|
    t.integer "award_type", default: 1
    t.string  "name"
    t.string  "img"
  end

  create_table "friends", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
  end

  create_table "records", force: true do |t|
    t.integer  "user_id"
    t.integer  "award_id"
    t.datetime "created_at"
  end

  create_table "shares", force: true do |t|
    t.integer  "share_user_id"
    t.integer  "click_user_id"
    t.integer  "share_time"
    t.datetime "created_at"
  end

  create_table "users", force: true do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "openid"
    t.string   "nickname"
    t.integer  "sex",             default: 1
    t.string   "province"
    t.string   "city"
    t.string   "country"
    t.string   "headimgurl"
    t.integer  "today_gua_count", default: 2
    t.datetime "last_get_time"
    t.integer  "award_1",         default: 0
    t.integer  "award_2",         default: 0
    t.integer  "award_3",         default: 0
    t.integer  "award_4",         default: 0
    t.integer  "award_5",         default: 0
    t.integer  "award_6",         default: 0
    t.string   "name"
    t.string   "address"
    t.integer  "hy_count",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
