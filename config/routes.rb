YamsCore::Engine.routes.draw do

  # TODO - is this really the right place for this ... need to prevent error :
  #   Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true
  default_url_options :host => "localhost:3000"    # TODO: if really needed use dotenv

  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }, module: :devise, class_name: "YamsCore::User"

  devise_scope :user do
    get 'users/:id' => 'users/registrations#show', as: :user, module: :devise, class_name: "YamsCore::User"
  end

  namespace :admin do
    resources :users
    root to: "users#index"
  end

  resources :artists, only: [:show]

  resources :albums, module: 'album'

  namespace :album do
    resources :management, only: [:index]

    resources :tracks, only: [:create, :destroy]
  end

  resources :playlists, module: 'playlist'

  namespace :playlist do
    resources :management, only: [:index]

    resources :tracks, only: [:create, :destroy]
  end

  resource :radio, only: [:create, :show], controller: :radio

  resources :id3_genres
  resources :licenses

  #resource :audio_player_init, only: [:create], defaults: { :format => :json }, controller: 'audio_player_init'

  post 'player_status_callback', to: 'player_status_callback#create'

  resource :searches, only: [:show]

  resources :tracks, module: 'track'

  namespace :track do
    resources :albums, only: [:create]

    resource :bulk_uploads, only: [:new, :create]
    resources :bulk_upload_templates, only: [:show]
  end

  mount YamsAudioEngine::Engine, at: '/audio_engine'

end
