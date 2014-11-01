Rails.application.routes.draw do
  devise_for :users
  resources :herbalism_lists do
    collection do
      get :effects
    end

    resources :items, controller: "herbalism_list_items"
  end

  root to: "home#index"
end
