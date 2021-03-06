Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: "admin/admins/sessions"
  }

  devise_for :members, controllers: {
    sessions: "user/members/sessions",
    registrations: "user/members/registrations"
  }

  scope module: :user do
    root "home#top"
    get "about" => "home#about"
    resources :members, only: [:show, :edit, :update]
    resources :thanks, only: [:create, :destroy, :index, :edit, :update]
    get "tos" => "thanks#tos", as: "tos"
    get "froms" => "thanks#froms", as: "froms"
    resources :posts, only: [:show, :new, :create, :edit, :update, :destroy, :index] do
      resources :post_comments, only: [:create, :destroy]
      resource :cheerings, only: [:create, :destroy]
      resource :praises, only: [:create, :destroy]
    end
    get "search" => "searches#search"
  end

  namespace :admin do
    resources :members, only: [:index, :update, :destroy]
  end
end
