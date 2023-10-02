Rails.application.routes.draw do
  resources :transferences
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post '/transferences', to: 'transferences#create' 
end
