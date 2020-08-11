class AddStockItemsConstrants < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE stock_items ADD CONSTRAINT check_quantity CHECK (quantity >= 0 )"
    add_index :stock_items, [:product_id, :store_id], unique: true
  end

  def down
    execute "ALTER TABLE stock_items DROP CONSTRAINT check_quantity"
    remove_index :stock_items, name: 'index_stock_items_on_product_id_and_store_id'
  end
end
