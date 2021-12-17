Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
  
  root 'posts#index'
  get 'login', to: 'user_sessions#new'  
  post 'login', to: 'user_sessions#create'  
  delete 'logout', to: 'user_sessions#destroy' 
  patch "/read/:id", to: "activities#read"
  
  #post検索用path
  get 'posts/search', to: 'posts#search'
  #userプロフィール編集用path
  namespace :mypage do
    resources :account, only: %i[edit create]
  end

  resources :activities, only: [] do
    patch :read, on: :member
  end

  resources 'posts' do
    resources :comments, shallow: true
  end

  resources :likes, only: %i[create destroy]
  resources :users, only: %i[new create index show]
  resources :relationships, only: %i[create destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
