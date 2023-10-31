Rails.application.routes.draw do
  devise_for :users
  scope controller: "admin" do
    get "admin"
  end
  resources :categories do
    collection do
      get "sync"
    end
  end
  resources :users
  resources :fragrance_profiles
  resources :fragrances

  put :change_locale, controller: "application"
  root "sites#home"
end
