class CreateErpProductsProductsUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products_units do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :unit, index: true, references: :erp_products_units
      t.decimal :conversion_value, default: 1.0
      t.decimal :price, default: 0.0
      t.string :code
      
      t.timestamps
    end
  end
end
