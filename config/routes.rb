Lists::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  # authentication callback
  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks" }

  # Using Omniauth without other authentications
  # @see https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview#using-omniauth-without-other-authentications
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  # stack routes for the old part of the app (anonymous)
  resources :s, controller: :stacks, as: :stacks, only: [:index, :new, :show] do
    resources :lists, except: [:edit] do
      resources :tasks, except: [:new, :edit]
    end
  end

  # api routes
  namespace :api do
    resources :lists, only: [:index, :create, :show, :update, :destroy] do
      member do
        post 'share'
        delete 'unshare'
        delete 'leave'
        get 'contributors'
      end
      resources :tasks, only: [:index, :create, :show, :update, :destroy]
    end
  end

  get 'preview' => 'pages#preview'
  get 'dashboard' => 'pages#dashboard'
  get 'dashboard/*all', to: 'pages#dashboard'

  # You can have the root of your site routed with "root"
  root 'pages#home'

end
