class CreateErpProductsProductsParts < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products_parts do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :part, index: true, references: :erp_products_products
      t.integer :quantity, default: 1.0
      t.decimal :total, default: 0.0
      
      t.timestamps
    end
  end
end
