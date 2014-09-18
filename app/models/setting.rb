#encoding: utf-8
class Setting < Settingslogic
  source "#{Rails.root}/config/config.yml"
  namespace Rails.env
  load! if Rails.env.development?

  CACHE_PREFIX = 'rq_'
  def cache_get(key)
    Redis::Objects.redis.get(CACHE_PREFIX + key)
  end

  def cache_set(key, value, expire)
    Redis::Objects.redis.set(CACHE_PREFIX + key,value)
    Redis::Objects.redis.expire(CACHE_PREFIX + key,expire)
    value
  end

  def cache_set_value(key, value)
    # 默认1小时
    cache_set(key, value, 1.hour)
  end

  # 永不过期存储
  def set_ever(key, value)
    Redis::Objects.redis.set(CACHE_PREFIX + key,value)
    value
  end

  def cache_del(key)
    Redis::Objects.redis.del(CACHE_PREFIX + key)
  end

  def share_url(openid)
    Setting.local_url + "?mid=" + openid;
  end


end
