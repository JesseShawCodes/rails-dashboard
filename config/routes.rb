Rails.application.routes.draw do
  devise_for :users
  resources :users

  # 1. Root for Authenticated Users (Highest Priority)
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  # 2. Root for Unauthenticated Users (Fallback)
  # This acts as the default if a user is NOT authenticated.
  unauthenticated do
    # You can point to the Home page, or directly to the sign-in page
    root "home#index", as: :unauthenticated_root 
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end