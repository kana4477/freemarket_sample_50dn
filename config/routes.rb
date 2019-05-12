Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#index'
  resources :products, only: [:index, :new, :show] do
    get :buy, on: :member
  end
  resources :users do
    get :logout, on: :collection
    get :identification, on: :collection
  end
end
