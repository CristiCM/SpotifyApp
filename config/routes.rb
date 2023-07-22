Rails.application.routes.draw do

  root 'pages#home'

  devise_for :users , controllers: {
    registration: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :spotify_accounts
  # resources: spotify_accounts is == to
  # get "spotify_accounts/:id"
  # delete "spotify_accounts/:id"

end
