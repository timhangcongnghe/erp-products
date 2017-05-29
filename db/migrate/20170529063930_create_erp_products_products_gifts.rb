class CreateErpProductsProductsGifts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products_gifts do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :gift, index: true, references: :erp_products_products
      t.integer :quantity, default: 1
      t.decimal :price, default: 0.0

      t.timestamps
    end
  end
end
