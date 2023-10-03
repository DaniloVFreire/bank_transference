Rails.application.routes.draw do
  # Option 1 - Allow all controller actions
  #resources :transferences
  # Option 2 - Allow specific controller actions
  #resources :transferences, only: [:index, :create, :destroy]
  # Option 3 - Define specific controller action
  #get '/transferences', to: 'transferences#index'

  #post '/transferences', to: 'transferences#create' 
  resources :transferences, only: [:index, :create]

end
