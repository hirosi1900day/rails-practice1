Rails.application.routes.draw do
  root 'posts#index'
  get 'login', to: 'user_sessions#new'  
  post 'login', to: 'user_sessions#create'  
  delete 'logout', to: 'user_sessions#destroy' 
  
  #post検索用path
  get 'posts/search', to: 'posts#search'
  #userプロフィール編集用path
  namespace :mypage do
    resources :account, only: %i[edit create]
  end

  resources 'posts' do
    resources :comments, shallow: true
  end

  resources :likes, only: %i[create destroy]
  resources :users, only: %i[new create index show]
  resources :relationships, only: %i[create destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
