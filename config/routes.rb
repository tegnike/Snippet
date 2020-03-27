Rails.application.routes.draw do
  root to: 'home#index'
  # APIコントローラへのルーティング
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :snippets, only: [:index, :show, :create]
    end
  end
end
