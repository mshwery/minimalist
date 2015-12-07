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

  resources :s, controller: :stacks, as: :stacks, only: [:index, :new, :show] do
    resources :lists, except: [:edit] do
      resources :tasks, except: [:new, :edit]
    end
    # get '*wildcard', to: 'stack#show', as: :wildcard
  end

  scope 'api', as: 'api' do
    resources :lists, except: [:new, :index, :edit] do
      resources :tasks, except: [:new, :edit]
    end
  end

  get 'preview' => 'pages#preview'

  # You can have the root of your site routed with "root"
  root 'pages#home'

end
