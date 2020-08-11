class StockItem < ApplicationRecord
  belongs_to :product
  belongs_to :store

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates_presence_of :quantity
  validates :product_id, uniqueness: { scope: :store_id }
end
