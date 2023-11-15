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
  resources :images, only: :destroy
  resources :orders
  resources :users

  put :change_locale, controller: "application"

  controller :carts do
    post :add_item
  end

  controller :sites do
    get :products, action: :products, as: :products
    get "product/:id", action: :product, as: :product
  end
  root "sites#home"
end
