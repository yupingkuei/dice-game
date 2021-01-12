Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get 'users/edit'
  resources :games
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
