QuotesFromCollege::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  
  get 'terms',       to: 'pages#terms'
  get 'privacy',     to: 'pages#privacy'
  get 'sitemap.xml', to: 'pages#sitemap', format: :xml, as: :sitemap
  get 'robots.txt',  to: 'pages#robots', format: :text, as: :robots

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  resources :users

  resources :colleges, only: [:show] do
    collection do
      get 'names'
    end
  end

  resources :posts do
    collection do
      get  'vote'
      get  'search'
      get  'bestof'
      post 'vote_up'
      post 'vote_down'
    end
  end

  post 'sms', to: 'sms#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with 'rake routes'.

  # You can have the root of your site routed with 'root'
  root to: 'posts#index'
end
