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
  resources :catalog_items do
    resources :catalog_item_variations
    collection do
      get "sync"
    end
  end
  resources :fragrance_profiles
  resources :fragrances
  resources :users

  put :change_locale, controller: "application"
  root "sites#home"
end
