Rails.application.routes.draw do
  get 'game/index'
  get 'game/start_board'
  post 'game/make_move'
  post 'game/setup'
  root 'game#index'
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
