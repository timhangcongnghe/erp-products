class AddTimestampsToErpProductsProductImages < ActiveRecord::Migration[5.0]
  def change
    add_timestamps(:erp_products_product_images, default: Time.now)
  end
end
