Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    scope 'v1' do
      resources :operations, only: [:create]
      resources :balances, only: [:index]
    end
  end
end
