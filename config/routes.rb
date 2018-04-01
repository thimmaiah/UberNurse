Rails.application.routes.draw do




  resources :referrals
  namespace :admin do
    resources :users
    resources :care_homes
    resources :payments
    resources :post_codes
    resources :ratings
    resources :staffing_requests do
      collection do
        get :manual_shift_search_user
      end
      member do 
        get :find_care_givers
        post :manual_shift
      end
    end
    resources :shifts
    resources :user_docs
    resources :rates
    resources :referrals
    resources :holidays
    get '/payments_export', to: 'payments_export#index'
    get '/payments_export/form', to: 'payments_export#form'
    root to: "users#index"
  end


  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
  resources :ratings
  resources :payments
  resources :user_docs

  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords: 'passwords'
  }

  resources :hiring_responses
  resources :hiring_requests
  resources :care_homes
  resources :users do
    collection do
      post :send_sms_verification      
      post :verify_sms_verification
      post :resend_confirmation
    end
  end
  resources :post_codes
  resources :shifts
  resources :staffing_requests do
    collection do
      post :price
    end
  end
  resources :rates
  resources :holidays
  resources :cqc_records

  get 'users/unsubscribe/:unsubscribe_hash', to: 'users#unsubscribe', :as => 'unsubscribe'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
