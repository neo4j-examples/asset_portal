Rails.application.routes.draw do
  root 'assets#index'
  resources :categories
  resources :assets
end
