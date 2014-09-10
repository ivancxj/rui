Rails.application.routes.draw do

  root :to => "home#index"

  get 'oauth', :to => 'home#oauth'
  post 'gua', :to => 'home#gua'

  get 'my', :to => 'home#my'
  get 'friend', :to => 'home#friend'

end
