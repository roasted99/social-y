Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/create'
  get 'posts/destroy'
  get 'posts/edit'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"
end
