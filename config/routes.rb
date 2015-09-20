Lists::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :s, controller: :stacks, as: :stacks do
    resources :lists do
      resources :tasks
    end
  end

  resources :lists do
    resources :tasks
  end

  get 'preview' => 'pages#preview'

  # You can have the root of your site routed with "root"
  root 'pages#home'

end
