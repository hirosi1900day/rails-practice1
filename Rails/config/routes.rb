require 'sidekiq/web'

Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
    mount Sidekiq::Web, at: '/sidekiq'
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
    resource :account, only: %i[edit create]
    resource :notification_setting, only: %i[edit update]
    #決済関連
    resources :plans, only: %i[index]
    resources :payments, only: %i[index]
    resources :contracts, only: %i[create]
    resource :creditcard, only: %i[new create edit update]
    resource :contract, only: %i[create] do
      resource :contract_cancellation, module: :contract, path: :cancellation, only: :create
    end
  end

  resources :activities, only: %i[index] do
    patch :read, on: :member
  end

  resources 'posts' do
    resources :comments, shallow: true
  end

  resources :likes, only: %i[create destroy]
  resources :users, only: %i[new create index show]
  resources :relationships, only: %i[create destroy]
  resources :chatrooms, only: %i[ create index show ], shallow: true do
    resources :messages
  end

  



  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
