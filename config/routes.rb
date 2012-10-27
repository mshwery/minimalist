Lists::Application.routes.draw do
  
  resources :s, controller: :stacks, as: :stacks do
    resources :lists do
      resources :tasks
      resources :memberships
    end
  end

  resources :lists #, :only => [:new, :create] 

  root to: 'pages#home'

  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/logout", to: "sessions#destroy", :as => "logout"
  #resources :identity
end
