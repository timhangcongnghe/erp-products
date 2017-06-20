class AddIsSoldOutToErpProductsProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_products_products, :is_sold_out, :boolean, default: false
  end
end
