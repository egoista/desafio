class CreateStockItems < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_items do |t|
      t.integer :quantity
      t.references :product, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
