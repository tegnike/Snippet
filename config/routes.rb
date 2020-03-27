Rails.application.routes.draw do
  # APIコントローラへのルーティング
  namespace :api, {format: 'json'} do
    namespace :v1 do
      resources :snippets, only: [:index, :show]
    end
  end
end
