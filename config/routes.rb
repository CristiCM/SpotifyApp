Rails.application.routes.draw do

  root 'pages#home'

  devise_for :users , controllers: {
    registration: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :spotify_accounts do
    post 'previous', on: :member
    put 'play', on: :member
    put 'pause', on: :member
    post 'next', on: :member
    get 'current_playback', on: :member
  end
  

  # resources: spotify_accounts is == to
  # get "spotify_accounts/:id"
  # delete "spotify_accounts/:id"
end
