Rails.application.routes.draw do
  resources :promotions
  resources :workshops do 
    get :synthesis
  end
  devise_for :users
  resources :projects do
    collection do
      get 'synthesis'
    end
  end
  get 'users/me' => 'users#me', as: 'my_profile'
  patch 'users/me' => 'users#update_me', as: 'update_my_profile'
  get 'users/without-diploma' => 'users#without_diploma'
  get 'users/diploma/:year' => 'users#diploma', as: 'users_by_diploma'
  resources :users
  resources :features do
    collection do
      get 'synthesis'
    end
  end
  resources :fields
  root 'features#index'
end
