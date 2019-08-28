Rails.application.routes.draw do

  root 'tasks#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/signup', to: 'users#sign_up'
  post '/signup', to: 'users#sign_up_process'

  scope 'admin' do
    resources :users do
      member do
        get :tasks
      end
    end
  end

  resources :tasks do
    collection do
      get :list
      post :sort
    end
    member do
      get :show_user_task
    end
  end

end
