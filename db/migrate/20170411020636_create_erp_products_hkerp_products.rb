class CreateErpProductsHkerpProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_hkerp_products do |t|
      t.references :product, index: true, references: :erp_products_products
      t.integer :hkerp_product_id
      t.decimal :price, default: 0.0
      t.integer :stock, default: 0
      t.text :data

      t.timestamps
    end
  end
end
