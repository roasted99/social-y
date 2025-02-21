Rails.application.routes.draw do

  namespace :api, default: { format: :json } do 
    namespace :v1 do
      devise_for :users,path: '', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations'
      }

      devise_scope :user do
        post 'login', to: 'api/v1/users/sessions#create'
        delete 'logout', to: 'api/v1/users/sessions#destroy'
      end

      resources :posts do
        resources :comments, only: [:create, :destroy]
      end 
      
    end
  end

# devise_for :users 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html



  # resources :posts
  # Defines the root path route ("/")
  root to: "pages#index"
  get 'signup', to: 'pages#sign_up'
  get 'login', to: 'pages#sign_in'
  get 'profile', to: 'pages#profile'
  get 'post/:id', to: 'pages#post'

  # get 'posts', to: "posts#index"
  # post 'posts', to: 'posts#create'
  # get 'posts/:id', to: 'posts#show'
  # patch 'posts/:id', to: 'posts#edit'
  # put 'posts/:id', to: 'posts#edit'  # For completeness, since PUT and PATCH can both be used for updates
  
  # Define route for deleting a post
  # delete 'posts/:id', to: 'posts#destroy'
end
