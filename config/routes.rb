Rails.application.routes.draw do
  namespace :v1 do
    resources :stock_items
    resources :products
    resources :stores
  end
end
