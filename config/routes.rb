Rails.application.routes.draw do
  namespace :api, default: { format: 'json' } do 
    namespace :v1 do
     resources :posts
    end
  end
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :posts
  # Defines the root path route ("/")
  root to: "posts#index"
  post 'posts', to: 'posts#create'
  patch 'posts/:id', to: 'posts#edit'
  put 'posts/:id', to: 'posts#edit'  # For completeness, since PUT and PATCH can both be used for updates
  
  # Define route for deleting a post
  delete 'posts/:id', to: 'posts#destroy'
end
