Rails.application.routes.draw do
  devise_for :users
  scope controller: "admin" do
    get "admin"
  end
  resources :users

  put :change_locale, controller: "application"
  root "sites#home"
end
