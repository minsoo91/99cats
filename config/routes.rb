Rails.application.routes.draw do
  root to: 'cats#index'
  
  resource :user, only: [:new, :create, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :cats
  
  resources :cat_rental_requests, only: [:create, :destroy, :new] do
    member do
      patch 'approve'
      patch 'deny'
    end
  end  
end
