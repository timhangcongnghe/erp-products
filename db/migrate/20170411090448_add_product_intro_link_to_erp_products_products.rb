class AddProductIntroLinkToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :product_intro_link, :string
  end
end
