Rails.application.routes.draw do
  root 'assets#home'

  devise_for :users

  resources :categories

  get 'models' => 'models#index', as: :models
  get 'models/:name' => 'models#show', as: :model

  get 'authorizables/user_and_group_search.json' => 'authorizables#user_and_group_search'
  get 'authorizables/:model_slug/:id.:format' => 'authorizables#show'
  put 'authorizables/:model_slug/:id.:format' => 'authorizables#update'

  get ':model_slug' => 'assets#index', as: :assets
  get ':model_slug/:id' => 'assets#show', as: :asset
  get ':model_slug/:id/edit' => 'assets#edit', as: :edit_asset
  patch ':model_slug/:id' => 'assets#update'
end
