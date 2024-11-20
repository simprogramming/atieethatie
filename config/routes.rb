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
  resources :orders do
    member do
      put :shipped
    end
  end
  resources :users

  put :change_locale, controller: "application"

  controller :carts do
    post :add_item
    delete "remove_item/:id", to: "carts#remove_item", as: :remove_item
    get :cart_page
    get :checkout
    get "receipt/:id", action: :receipt, as: :receipt
    post :process_square_payment
    post :apply_promo_code
  end

  controller :sites do
    get :products, action: :products, as: :products
    get "product/:id", action: :product, as: :product
    get :about, action: :about, as: :about
    get :policy_return, action: :policy_return, as: :policy_return
  end
  root "sites#home"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
