Rails.application.routes.draw do
  devise_for :users
  resources :herbalism_lists
  root to: "home#index"
end
