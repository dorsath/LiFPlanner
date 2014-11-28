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
    resource :todo_list, controller: "towns/todo_lists" do
      resources :items, controller: "towns/todo_items"
      collection do
        get :changed
      end
    end

    resource :planner, controller: "towns/planner" do
      resources :buildings, controller: "towns/planner/buildings"
      get '/height_maps', to: "towns/planner/height_maps#index"
      get '/height_maps/changed', to: "towns/planner/height_maps#changed"
      resource :height_maps, controller: "towns/planner/height_maps", path: "/height_maps/:x/:y"
      collection do
        get :changed
      end
    end


  end

  post '/pending_invites/:id/accept', to: 'pending_invites#accept', as: 'accept_pending_invite'
  


  root to: "home#index"
end
