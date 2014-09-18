# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Award.create(award_type: 1, name: '充电宝', count: 60)
Award.create(award_type: 2, name: '电影票', count: 50)
Award.create(award_type: 3, name: '料理机', count: 2)
Award.create(award_type: 4, name: '电影票', count: 20)


opt={}
opt[:access_token] = 'access_token'
opt[:refresh_token] = 'refresh_token'
opt[:openid] = 'ozmMMt8Irb8htU_jlRVX3Ekkzov8'
opt[:nickname] = 'nickname'
opt[:sex] = 1

opt[:today_gua_count] = 10
opt[:last_get_time] = Time.now
user = User.new(opt)
user.save