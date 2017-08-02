Rails.application.routes.draw do
  get 'game/index'
  get 'game/board'
  root 'game#index'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
