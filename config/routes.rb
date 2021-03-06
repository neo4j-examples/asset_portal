Rails.application.routes.draw do
  mathjax 'mathjax'

  # Routes for GraphGist portal
  get 'graph_gists/submit' => 'graph_gists#submit'
  get 'graph_gists/preview' => 'graph_gists#preview', as: :graph_gist_preview

  get 'graph_gists/search' => 'graph_gists#search'

  # Routes for asset_portal
  resources :groups
  root 'assets#home'

  devise_for :users

  resources :categories
  resources :groups do
    member do
      get :users_to_add
    end
  end
  resources :users

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
