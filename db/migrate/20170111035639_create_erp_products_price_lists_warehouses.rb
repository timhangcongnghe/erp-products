class CreateErpProductsPriceListsWarehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_price_lists_warehouses do |t|
      t.references :price_list, index: true, references: :erp_products_price_lists
      t.references :warehouse, index: true, references: :erp_products_warehouses

      t.timestamps
    end
  end
end
