Rails.application.routes.draw do
  devise_for :users
  resources :herbalism_lists do
    collection do
      get :effects
    end

    resources :items, controller: "herbalism_list_items"
  end

  resources :towns do
    resources :pending_invites
    resources :herbalism_lists, controller: "towns/herbalism_lists"
  end

  post '/pending_invites/:id/accept', to: 'pending_invites#accept', as: 'accept_pending_invite'
  


  root to: "home#index"
end
