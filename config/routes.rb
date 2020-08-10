Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :v1 do
    resources :products, only: [:create, :update, :destroy] do
      collection do
        get 'search'
      end
    end
    resources :stores, only: [:create, :update, :destroy] do
      collection do
        get 'search'
      end
      member do
        post 'stock_item'
        patch 'stock_item/add'
        put 'stock_item/add'
        patch 'stock_item/remove'
        put 'stock_item/remove'
      end
    end
  end
end
