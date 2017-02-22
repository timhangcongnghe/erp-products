class CreateErpProductsStockCheckDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_stock_check_details do |t|
      t.integer :quantity, default: 1
      t.text :note
      t.references :product, index: true, references: :erp_products_products
      t.references :stock_check, index: true, references: :erp_products_stock_checks

      t.timestamps
    end
  end
end
