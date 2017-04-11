class AddImageUrlToErpProductsBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_brands, :image_url, :string
  end
end
