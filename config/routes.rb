Rails.application.routes.draw do
  resources :songs
  resources :artists

  resources :artists, only: [:show] do
    resources :songs, only: [:show, :index]
  end
end
