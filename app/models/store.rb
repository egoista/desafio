class Store < ApplicationRecord
  has_many :stock_items

  validates_presence_of :name, :address
end
