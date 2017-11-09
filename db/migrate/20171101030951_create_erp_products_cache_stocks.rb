class CreateErpProductsCacheStocks < ActiveRecord::Migration[5.1]
  def change
    create_table :erp_products_cache_stocks do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :state, index: true, references: :erp_products_states
      t.references :warehouse, index: true, references: :erp_warehouses_warehouses
      t.integer :stock, default: 0, index: true

      t.timestamps
    end
  end
end
