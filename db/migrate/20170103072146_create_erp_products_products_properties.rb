class CreateErpProductsProductsProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_products_properties do |t|
      t.references :property, index: true, references: :erp_products_properties
      t.references :product, index: true, references: :erp_products_products

      t.timestamps
    end
  end
end
