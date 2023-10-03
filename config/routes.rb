Rails.application.routes.draw do
  # Option 1 - Allow all controller actions
  #resources :transferences
  # Option 2 - Allow specific controller actions
  #resources :transferences, only: [:index, :create, :destroy]
  # Option 3 - Define specific controller action
  #get '/transferences', to: 'transferences#index'

  #post '/transferences', to: 'transferences#create' 
  resources :transferences, only: [:index, :create, :destroy, :show]

  get "/transferences/made/:origin_account", to: "transferences#show_made_transferences"
  get "/transferences/all/:account_or_pix_key", to: "transferences#show_all_transferences"
  get "/transferences/recived/:account_or_pix_key", to: "transferences#show_recived_transferences"
end
