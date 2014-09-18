Rails.application.routes.draw do

  root :to => "home#index"

  get 'oauth', :to => 'home#oauth'
  post 'gua', :to => 'home#gua'
  post 'go_gua', :to => 'home#go_gua'
  post 'duihuan', :to => 'home#duihuan'

  get 'my', :to => 'home#my'

  # 助政好友
  get 'friend', :to => 'home#friend'

  # 活动介绍
  get 'jieshao', :to => 'home#jieshao'

  # 获奖名单
  get 'mingdan', :to => 'home#mingdan'

  # 点击分享提示
  get 'share_hint', :to => 'home#share_hint'

  get 'demo', :to => 'home#demo'

end
