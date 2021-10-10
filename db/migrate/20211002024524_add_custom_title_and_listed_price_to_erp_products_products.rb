class AddCustomTitleAndListedPriceToErpProductsProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :erp_products_products, :custom_title, :string
    add_column :erp_products_products, :listed_price, :decimal, default: 0.0
  end
end
