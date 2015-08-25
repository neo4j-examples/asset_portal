Rails.application.routes.draw do
  root 'assets#home'

  resources :categories

  get '/:model_slug' => 'assets#index', as: :assets
  get '/:model_slug/:id' => 'assets#show', as: :asset
  get '/:model_slug/:id/edit' => 'assets#edit', as: :edit_asset
  patch '/:model_slug/:id' => 'assets#update'
end
