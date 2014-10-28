Rails.application.routes.draw do
  resources :cats
  resources :cat_rental_requests, only: [:create, :destroy, :new] do
    member do
      patch 'approve'
      patch 'deny'
    end
  end
  root to: 'cats#index'
end
