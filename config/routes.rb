Rails.application.routes.draw do
  resources :stock_items
  resources :products
  resources :stores
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
