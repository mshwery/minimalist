Lists::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
