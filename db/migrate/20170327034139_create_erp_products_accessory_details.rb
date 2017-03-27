class CreateErpProductsAccessoryDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_accessory_details do |t|
      t.references :product, index: true, references: :erp_products_products
      t.references :accessory, index: true, references: :erp_products_accessories

      t.timestamps
    end
  end
end
