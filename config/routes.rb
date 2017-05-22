Rails.application.routes.draw do
  
  

  namespace :admin do
    resources :users
    resources :care_homes
    resources :payments
    resources :post_codes
    resources :ratings
    resources :staffing_requests
    resources :staffing_responses
    resources :user_docs
    get '/payments_export', to: 'payments_export#index'
    root to: "users#index"
  end

  

  resources :ratings
  resources :payments
  resources :user_docs
  mount_devise_token_auth_for 'User', at: 'auth'
  
  resources :hiring_responses
  resources :hiring_requests
  resources :care_homes
  resources :users
  resources :post_codes
  resources :staffing_responses
  resources :staffing_requests

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
