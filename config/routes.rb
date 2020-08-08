Rails.application.routes.draw do
  resources :categories, except: [:destroy]
  root 'pages#home'
  get 'about', to: 'pages#about'
  resources :articles
  get 'signup', to: 'users#new'
  resources :users, except: [:new]
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'search_user', to: 'users#search'
  get 'search_article', to: 'articles#search'
  get 'search_category', to: 'categories#search'
end
