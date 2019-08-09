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

  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server_error'

end
