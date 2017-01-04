class CreateErpProductsProductImages < ActiveRecord::Migration[5.0]
  def change
    create_table :erp_products_product_images do |t|
      t.references :product, index: true, references: :erp_products_products
      t.string :image_url
    end
  end
end
