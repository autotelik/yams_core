YamsCore::Engine.routes.draw do

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }, module: :devise, class_name: "YamsCore::User"

  devise_scope :user do
    get 'users/:id' => 'users/registrations#show', as: :user, module: :devise, class_name: "YamsCore::User"
  end

  resources :albums do
    delete :tracks, as: :clear_tracks
  end

  resources :album_tracks, only: [:create, :destroy, :edit, :index], module: 'album_track' do
    resources :track_selections, only: [:create]
  end

  post 'player_init', to: 'player_init#create'

  resources :playlists, module: 'playlist'

  namespace :playlist do
    resources :management, only: [:index]

    resources :tracks, only: [:create, :destroy]
  end

  resources :radio, only: [:index]

  resources :id3_genres
  resources :licenses

  resource :searches, only: [:show]
  resources :tracks

  mount DatashiftAudioEngine::Engine, at: "/audio"

  post 'player_status_callback', to: 'player_status_callback#create'

end
