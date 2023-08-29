Rails.application.routes.draw do

  resources :articles do
    resources :comments, only: [:index, :create]
    member do
      put :make_private
      put :make_public
    end
  end 

  resources :comments, only: [:update, :destroy]
  
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  get '/member-data', to: 'members#show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end