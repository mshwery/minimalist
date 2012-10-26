Lists::Application.routes.draw do
  
  resources :s, controller: :stacks, as: :stacks do
    resources :lists do
      resources :tasks
    end
  end

  resources :lists, only: [:new, :create] 

  root to: 'pages#home'

  match "/login", to: "sessions#new"
  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  resources :identities
end
