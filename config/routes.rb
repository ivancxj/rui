Rails.application.routes.draw do

  root :to => "home#index"

  get 'oauth', :to => 'home#oauth'
  post 'gua', :to => 'home#gua'

end
