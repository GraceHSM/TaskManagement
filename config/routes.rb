Rails.application.routes.draw do

  root 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#new'
  scope 'admin' do
    resources :users
  end

  resources :tasks

end
